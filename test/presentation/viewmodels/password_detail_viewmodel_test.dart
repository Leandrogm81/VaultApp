import 'package:flutter_test/flutter_test.dart';

import 'package:vaultapp/presentation/viewmodels/password_detail_viewmodel.dart';

void main() {
  group('PasswordDetailState', () {
    test('estado inicial deve ter valores padrao', () {
      final state = PasswordDetailState.initial();
      expect(state.password, isNull);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
    });

    test('copyWith deve criar copia com campos alterados', () {
      final state = PasswordDetailState.initial();
      final copy = state.copyWith(isLoading: true);
      expect(copy.isLoading, true);
      expect(copy.password, isNull);
    });

    test('copyWith com clearError deve limpar mensagem', () {
      final state = PasswordDetailState(errorMessage: 'erro');
      final copy = state.copyWith(clearError: true);
      expect(copy.errorMessage, isNull);
    });

    test('copyWith preserva campos nao alterados', () {
      final state = PasswordDetailState(
        isLoading: true,
        errorMessage: 'erro',
      );
      final copy = state.copyWith(isLoading: false);
      expect(copy.errorMessage, 'erro');
      expect(copy.isLoading, false);
    });
  });
}
