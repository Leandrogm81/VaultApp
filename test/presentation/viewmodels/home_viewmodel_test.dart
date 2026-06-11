import 'package:flutter_test/flutter_test.dart';

import 'package:vaultapp/presentation/viewmodels/home_viewmodel.dart';
import 'package:vaultapp/domain/entities/password.dart';

void main() {
  group('HomeState', () {
    test('estado inicial deve ter valores padrao', () {
      final state = HomeState.initial();
      expect(state.passwords, isEmpty);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
      expect(state.isEmpty, false);
    });

    test('copyWith deve criar copia com campos alterados', () {
      final state = HomeState.initial();
      final copy = state.copyWith(
        isLoading: true,
        isEmpty: true,
      );
      expect(copy.isLoading, true);
      expect(copy.isEmpty, true);
      expect(copy.errorMessage, isNull);
    });

    test('copyWith com clearError deve limpar mensagem', () {
      final state = HomeState(errorMessage: 'erro');
      final copy = state.copyWith(clearError: true);
      expect(copy.errorMessage, isNull);
    });

    test('copyWith preserva campos nao alterados', () {
      final passwords = [
        Password(
          id: '1',
          title: 'Test',
          username: 'user',
          password: 'pass',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      final state = HomeState(passwords: passwords, isEmpty: true);
      final copy = state.copyWith(isLoading: true);
      expect(copy.passwords, passwords);
      expect(copy.isEmpty, true);
      expect(copy.isLoading, true);
    });
  });
}
