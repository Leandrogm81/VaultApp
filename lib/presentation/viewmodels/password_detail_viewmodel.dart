import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../domain/entities/password.dart';
import 'home_viewmodel.dart';

/// Provider do PasswordDetailNotifier.
final passwordDetailProvider =
    NotifierProvider.family<PasswordDetailNotifier, PasswordDetailState, String>(
  PasswordDetailNotifier.new,
);

/// Estado da tela de detalhe da senha.
class PasswordDetailState {
  /// A senha carregada (null antes de carregar).
  final Password? password;

  /// Se esta carregando.
  final bool isLoading;

  /// Mensagem de erro (null quando nao ha erro).
  final String? errorMessage;

  const PasswordDetailState({
    this.password,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Estado inicial padrao.
  factory PasswordDetailState.initial() => const PasswordDetailState();

  /// Cria uma copia com campos alterados.
  PasswordDetailState copyWith({
    Password? password,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PasswordDetailState(
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// ViewModel para a tela de detalhe da senha (Notifier do Riverpod 3.x).
///
/// Gerencia estado: carregando senha, dados carregados, erro.
/// Conecta UI ao DAO Password.
class PasswordDetailNotifier extends Notifier<PasswordDetailState> {
  /// ID da senha a ser carregada.
  final String passwordId;

  PasswordDetailNotifier(this.passwordId);

  @override
  PasswordDetailState build() {
    // Carrega a senha ao construir
    Future.microtask(() => loadPassword());
    return PasswordDetailState.initial();
  }

  /// Carrega a senha pelo ID.
  Future<void> loadPassword() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final dao = ref.read(passwordDaoProvider);
      final row = await dao.getById(passwordId);

      if (row == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Senha nao encontrada',
        );
        return;
      }

      final password = _rowToPassword(row);
      state = state.copyWith(
        isLoading: false,
        password: password,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar senha',
      );
    }
  }

  /// Exclui a senha pelo ID.
  Future<bool> deletePassword() async {
    try {
      final dao = ref.read(passwordDaoProvider);
      await dao.deleteById(passwordId);
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao excluir senha',
      );
      return false;
    }
  }

  /// Converte uma linha do banco para a entidade Password.
  Password _rowToPassword(PasswordsTableData row) {
    return Password(
      id: row.id,
      categoryId: row.categoryId,
      title: row.title,
      username: row.username,
      password: row.password,
      url: row.url,
      notes: row.notes,
      tags: const [], // TODO: parse JSON tags quando implementado
      favorite: row.favorite,
      createdAt: DateTime.tryParse(row.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(row.updatedAt) ?? DateTime.now(),
    );
  }
}
