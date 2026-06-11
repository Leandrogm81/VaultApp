import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../domain/entities/password.dart';
import 'home_viewmodel.dart';

/// Provider do SearchNotifier.
final searchProvider = NotifierProvider<SearchNotifier, SearchState>(() {
  return SearchNotifier();
});

/// Provider assincrono para buscar tags existentes no vault.
final existingTagsProvider = FutureProvider<List<String>>((ref) async {
  final dao = ref.read(passwordDaoProvider);
  final rows = await dao.getAll();
  final tags = <String>{};

  for (final row in rows) {
    if (row.tags.isNotEmpty && row.tags != '[]') {
      try {
        final decoded = jsonDecode(row.tags);
        if (decoded is List) {
          tags.addAll(decoded.map((e) => e.toString()));
        }
      } catch (_) {}
    }
  }

  return tags.toList()..sort();
});

/// Estado da busca.
class SearchState {
  /// Resultados da busca.
  final List<Password> results;

  /// Query atual.
  final String query;

  /// Se esta carregando.
  final bool isLoading;

  /// Mensagem de erro (null quando nao ha erro).
  final String? errorMessage;

  /// Se a busca esta ativa (query nao vazia).
  final bool isActive;

  const SearchState({
    this.results = const [],
    this.query = '',
    this.isLoading = false,
    this.errorMessage,
    this.isActive = false,
  });

  /// Estado inicial padrao.
  factory SearchState.initial() => const SearchState();

  /// Cria uma copia com campos alterados.
  SearchState copyWith({
    List<Password>? results,
    String? query,
    bool? isLoading,
    String? errorMessage,
    bool? isActive,
    bool clearError = false,
  }) {
    return SearchState(
      results: results ?? this.results,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isActive: isActive ?? this.isActive,
    );
  }
}

/// ViewModel para a barra de pesquisa (Notifier do Riverpod 3.x).
///
/// Gerencia estado: query atual, resultados da busca, loading, erro.
/// Conecta UI ao Search DAO.
class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() {
    return SearchState.initial();
  }

  /// Busca senhas pelo query informado.
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      query: query,
      isActive: true,
      clearError: true,
    );

    try {
      final dao = ref.read(passwordDaoProvider);
      final rows = await dao.searchPasswords(query.trim());
      final passwords = rows.map(_rowToPassword).toList();

      state = state.copyWith(
        isLoading: false,
        results: passwords,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao buscar senhas',
      );
    }
  }

  /// Limpa a busca e restaura estado inicial.
  void clearSearch() {
    state = SearchState.initial();
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
      tags: const [],
      favorite: row.favorite,
      createdAt: DateTime.tryParse(row.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(row.updatedAt) ?? DateTime.now(),
    );
  }
}
