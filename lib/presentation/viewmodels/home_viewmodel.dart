import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/daos/password_dao.dart';
import '../../domain/entities/password.dart';
/// Provider do AppDatabase (compartilhado entre telas).
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Provider do PasswordDao.
final passwordDaoProvider = Provider<PasswordDao>((ref) {
  final db = ref.read(appDatabaseProvider);
  return PasswordDao(db);
});

/// Provider do HomeNotifier.
final homeProvider = NotifierProvider<HomeNotifier, HomeState>(() {
  return HomeNotifier();
});

/// Estado da tela Home.
class HomeState {
  /// Lista de senhas carregadas.
  final List<Password> passwords;

  /// Se esta carregando.
  final bool isLoading;

  /// Mensagem de erro (null quando nao ha erro).
  final String? errorMessage;

  /// Se a lista esta vazia.
  final bool isEmpty;

  /// Se o filtro de favoritos esta ativo.
  final bool showFavoritesOnly;

  const HomeState({
    this.passwords = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isEmpty = false,
    this.showFavoritesOnly = false,
  });

  /// Estado inicial padrao.
  factory HomeState.initial() => const HomeState();

  /// Cria uma copia com campos alterados.
  HomeState copyWith({
    List<Password>? passwords,
    bool? isLoading,
    String? errorMessage,
    bool? isEmpty,
    bool? showFavoritesOnly,
    bool clearError = false,
  }) {
    return HomeState(
      passwords: passwords ?? this.passwords,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isEmpty: isEmpty ?? this.isEmpty,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
    );
  }
}

/// ViewModel para a tela Home (Notifier do Riverpod 3.x).
///
/// Gerencia estado da lista de senhas: loading, loaded, empty, error.
/// Conecta UI ao DAO Password. Suporta filtro de favoritos.
class HomeNotifier extends Notifier<HomeState> {
  /// Lista completa de senhas (antes do filtro).
  List<Password> _allPasswords = [];

  @override
  HomeState build() {
    return HomeState.initial();
  }

  /// Carrega todas as senhas do banco de dados.
  Future<void> loadPasswords() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final dao = ref.read(passwordDaoProvider);
      final rows = await dao.getAll();

      _allPasswords = rows.map(_rowToPassword).toList();
      _applyFilter();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar senhas',
      );
    }
  }

  /// Alterna o filtro de favoritos.
  void toggleFavoritesFilter() {
    state = state.copyWith(showFavoritesOnly: !state.showFavoritesOnly);
    _applyFilter();
  }

  /// Aplica o filtro atual (favoritos ou todos).
  void _applyFilter() {
    List<Password> filtered;
    if (state.showFavoritesOnly) {
      filtered = _allPasswords.where((p) => p.favorite).toList();
    } else {
      filtered = List.from(_allPasswords);
    }

    state = state.copyWith(
      isLoading: false,
      passwords: filtered,
      isEmpty: filtered.isEmpty,
    );
  }

  /// Exclui uma senha pelo ID e recarrega a lista.
  Future<void> deletePassword(String id) async {
    try {
      final dao = ref.read(passwordDaoProvider);
      await dao.deleteById(id);
      await loadPasswords();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao excluir senha',
      );
    }
  }

  /// Recarrega a lista de senhas (pull-to-refresh).
  Future<void> refresh() async {
    await loadPasswords();
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
      tags: _parseTags(row.tags),
      favorite: row.favorite,
      createdAt: DateTime.tryParse(row.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(row.updatedAt) ?? DateTime.now(),
    );
  }

  /// Faz parse de tags de JSON array string para List<String>.
  List<String> _parseTags(String tagsJson) {
    if (tagsJson.isEmpty || tagsJson == '[]') return [];
    try {
      final decoded = jsonDecode(tagsJson);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return [];
  }
}
