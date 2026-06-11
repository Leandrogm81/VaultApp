import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaultapp/presentation/viewmodels/search_viewmodel.dart';

void main() {
  group('SearchState', () {
    test('estado inicial deve ter campos padrao', () {
      final state = SearchState.initial();
      expect(state.results, isEmpty);
      expect(state.query, '');
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
      expect(state.isActive, false);
    });

    test('copyWith deve alterar campos especificos', () {
      final state = SearchState.initial();
      final updated = state.copyWith(query: 'test', isActive: true);
      expect(updated.query, 'test');
      expect(updated.isActive, true);
      expect(updated.results, isEmpty);
    });

    test('copyWith com clearError deve limpar mensagem de erro', () {
      final state = SearchState(errorMessage: 'erro');
      final updated = state.copyWith(clearError: true);
      expect(updated.errorMessage, isNull);
    });

    test('copyWith deve manter valores existentes', () {
      final state = SearchState(query: 'test', isActive: true);
      final updated = state.copyWith(isLoading: true);
      expect(updated.query, 'test');
      expect(updated.isActive, true);
      expect(updated.isLoading, true);
    });
  });

  group('SearchNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('build deve retornar estado inicial', () {
      final state = container.read(searchProvider);
      expect(state.query, '');
      expect(state.results, isEmpty);
      expect(state.isActive, false);
    });

    test('clearSearch deve restaurar estado inicial', () {
      final notifier = container.read(searchProvider.notifier);
      notifier.clearSearch();
      final state = container.read(searchProvider);
      expect(state.query, '');
      expect(state.results, isEmpty);
      expect(state.isActive, false);
    });

    test('search com query vazia deve limpar busca', () async {
      final notifier = container.read(searchProvider.notifier);
      await notifier.search('');
      final state = container.read(searchProvider);
      expect(state.isActive, false);
      expect(state.query, '');
    });

    test('search com query com espacos deve limpar busca', () async {
      final notifier = container.read(searchProvider.notifier);
      await notifier.search('   ');
      final state = container.read(searchProvider);
      expect(state.isActive, false);
    });
  });
}
