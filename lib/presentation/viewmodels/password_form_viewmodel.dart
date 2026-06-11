import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../domain/entities/password.dart';
import 'home_viewmodel.dart';

/// Provider do PasswordFormNotifier.
final passwordFormProvider =
    NotifierProvider<PasswordFormNotifier, PasswordFormState>(() {
  return PasswordFormNotifier();
});

/// Estado do formulario de senha.
class PasswordFormState {
  /// Titulo da senha.
  final String title;

  /// Nome de usuario.
  final String username;

  /// Senha.
  final String password;

  /// URL do servico.
  final String url;

  /// Notas.
  final String notes;

  /// Se esta nos favoritos.
  final bool isFavorite;

  /// Se esta em modo edicao.
  final bool isEditing;

  /// ID da senha sendo editada (null para criacao).
  final String? editingId;

  /// Erros de validacao por campo.
  final Map<String, String> errors;

  /// Se esta submetendo.
  final bool isSubmitting;

  /// Se a submissao foi bem-sucedida.
  final bool submitSuccess;

  /// Mensagem de erro geral.
  final String? errorMessage;

  const PasswordFormState({
    this.title = '',
    this.username = '',
    this.password = '',
    this.url = '',
    this.notes = '',
    this.isFavorite = false,
    this.isEditing = false,
    this.editingId,
    this.errors = const {},
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.errorMessage,
  });

  /// Estado inicial padrao.
  factory PasswordFormState.initial() => const PasswordFormState();

  /// Cria uma copia com campos alterados.
  PasswordFormState copyWith({
    String? title,
    String? username,
    String? password,
    String? url,
    String? notes,
    bool? isFavorite,
    bool? isEditing,
    String? editingId,
    Map<String, String>? errors,
    bool? isSubmitting,
    bool? submitSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PasswordFormState(
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      isEditing: isEditing ?? this.isEditing,
      editingId: editingId ?? this.editingId,
      errors: errors ?? this.errors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// ViewModel para o formulario de senha (Notifier do Riverpod 3.x).
///
/// Gerencia estado: campos, validacao, submissao, erro.
class PasswordFormNotifier extends Notifier<PasswordFormState> {
  @override
  PasswordFormState build() {
    return PasswordFormState.initial();
  }

  /// Reseta estado para criacao de nova senha.
  void initializeForCreate() {
    state = PasswordFormState.initial();
  }

  /// Preenche campos para edicao de senha existente.
  void initializeForEdit(Password password) {
    state = PasswordFormState(
      title: password.title,
      username: password.username,
      password: password.password,
      url: password.url ?? '',
      notes: password.notes ?? '',
      isFavorite: password.favorite,
      isEditing: true,
      editingId: password.id,
    );
  }

  /// Atualiza um campo do formulario.
  void updateField(String field, String value) {
    switch (field) {
      case 'title':
        state = state.copyWith(title: value);
      case 'username':
        state = state.copyWith(username: value);
      case 'password':
        state = state.copyWith(password: value);
      case 'url':
        state = state.copyWith(url: value);
      case 'notes':
        state = state.copyWith(notes: value);
    }
    // Limpa erro do campo atualizado
    if (state.errors.containsKey(field)) {
      final newErrors = Map<String, String>.from(state.errors);
      newErrors.remove(field);
      state = state.copyWith(errors: newErrors);
    }
  }

  /// Atualiza o estado de favorito.
  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }

  /// Valida campos obrigatorios. Retorna true se valido.
  bool validate() {
    final errors = <String, String>{};

    if (state.title.trim().isEmpty) {
      errors['title'] = 'Titulo e obrigatorio';
    }
    if (state.password.isEmpty) {
      errors['password'] = 'Senha e obrigatoria';
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  /// Limpa erros de validacao.
  void clearErrors() {
    state = state.copyWith(errors: {});
  }

  /// Submete o formulario — salva ou atualiza senha no DAO.
  Future<void> submit() async {
    if (!validate()) return;

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final dao = ref.read(passwordDaoProvider);
      final now = DateTime.now().toIso8601String();

      if (state.isEditing && state.editingId != null) {
        // Atualizar senha existente
        final existing = await dao.getById(state.editingId!);
        if (existing == null) {
          state = state.copyWith(
            isSubmitting: false,
            errorMessage: 'Senha nao encontrada',
          );
          return;
        }

        await dao.updatePassword(
          PasswordsTableCompanion.insert(
            id: existing.id,
            title: state.title.trim(),
            username: state.username.trim(),
            password: state.password,
            url: Value(state.url.trim().isEmpty ? null : state.url.trim()),
            notes: Value(state.notes.trim().isEmpty ? null : state.notes.trim()),
            favorite: Value(state.isFavorite),
            createdAt: existing.createdAt,
            updatedAt: now,
          ),
        );
      } else {
        // Criar nova senha
        final id = _generateId();
        await dao.insertPassword(
          PasswordsTableCompanion.insert(
            id: id,
            title: state.title.trim(),
            username: state.username.trim(),
            password: state.password,
            url: Value(state.url.trim().isEmpty ? null : state.url.trim()),
            notes: Value(state.notes.trim().isEmpty ? null : state.notes.trim()),
            favorite: Value(state.isFavorite),
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      state = state.copyWith(
        isSubmitting: false,
        submitSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Erro ao salvar senha',
      );
    }
  }

  /// Gera um ID unico (UUID v4 simplificado).
  String _generateId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = (now * 10000 + now % 10000);
    return '$random-${now.toRadixString(16)}';
  }
}
