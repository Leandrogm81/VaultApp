import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/domain/entities/vault_state.dart';

void main() {
  group('VaultState', () {
    test('deve ter estado inicial padrao', () {
      final state = VaultState.initial();

      expect(state.locked, true);
      expect(state.failedAttempts, 0);
      expect(state.lockUntil, isNull);
    });

    test('deve aceitar todos os campos', () {
      final lockTime = DateTime(2026, 6, 10, 12, 30);
      final state = VaultState(
        locked: false,
        failedAttempts: 3,
        lockUntil: lockTime,
      );

      expect(state.locked, false);
      expect(state.failedAttempts, 3);
      expect(state.lockUntil, lockTime);
    });

    test('copyWith deve criar copia com campos alterados', () {
      final original = VaultState.initial();
      final copy = original.copyWith(
        locked: false,
        failedAttempts: 5,
      );

      expect(copy.locked, false);
      expect(copy.failedAttempts, 5);
      expect(copy.lockUntil, isNull); // nao alterado
    });

    test('copyWith deve preservar lockUntil quando nao informado', () {
      final lockTime = DateTime(2026, 6, 10, 12, 30);
      final original = VaultState(
        locked: true,
        failedAttempts: 3,
        lockUntil: lockTime,
      );

      final copy = original.copyWith(failedAttempts: 4);

      expect(copy.lockUntil, lockTime);
    });
  });
}
