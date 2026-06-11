import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/presentation/viewmodels/lock_viewmodel.dart';

void main() {
  group('LockState', () {
    test('estado inicial deve ter valores padrao', () {
      final state = LockState.initial();
      expect(state.password, '');
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
      expect(state.mode, LockMode.auth);
    });

    test('copyWith deve criar copia com campos alterados', () {
      final state = LockState.initial();
      final copy = state.copyWith(
        password: '123',
        isLoading: true,
        mode: LockMode.setup,
      );
      expect(copy.password, '123');
      expect(copy.isLoading, true);
      expect(copy.mode, LockMode.setup);
      expect(copy.errorMessage, isNull);
    });

    test('copyWith com clearError deve limpar mensagem', () {
      final state = LockState(errorMessage: 'erro');
      final copy = state.copyWith(clearError: true);
      expect(copy.errorMessage, isNull);
    });
  });
}
