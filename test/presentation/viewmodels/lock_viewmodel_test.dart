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
      expect(state.isLockedOut, false);
      expect(state.lockUntil, isNull);
      expect(state.failedAttempts, 0);
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

    test('copyWith deve preservar campos de bloqueio', () {
      final lockTime = DateTime.now().add(const Duration(minutes: 5));
      final state = LockState(
        isLockedOut: true,
        lockUntil: lockTime,
        failedAttempts: 5,
      );
      final copy = state.copyWith(password: 'test');
      expect(copy.isLockedOut, true);
      expect(copy.lockUntil, lockTime);
      expect(copy.failedAttempts, 5);
      expect(copy.password, 'test');
    });

    test('copyWith com clearLockUntil deve limpar lockUntil', () {
      final state = LockState(
        isLockedOut: true,
        lockUntil: DateTime.now().add(const Duration(minutes: 5)),
      );
      final copy = state.copyWith(clearLockUntil: true);
      expect(copy.lockUntil, isNull);
    });
  });
}
