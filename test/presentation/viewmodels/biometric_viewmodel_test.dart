import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/presentation/viewmodels/biometric_viewmodel.dart';

void main() {
  group('BiometricState', () {
    test('estado inicial deve ter valores padrao', () {
      final state = BiometricState.initial();
      expect(state.isAvailable, false);
      expect(state.isAuthenticating, false);
      expect(state.errorMessage, isNull);
      expect(state.biometricTypes, isEmpty);
      expect(state.isEnabled, false);
    });

    test('copyWith deve criar copia com campos alterados', () {
      final state = BiometricState.initial();
      final copy = state.copyWith(
        isAvailable: true,
        isEnabled: true,
      );
      expect(copy.isAvailable, true);
      expect(copy.isEnabled, true);
      expect(copy.isAuthenticating, false);
    });

    test('copyWith com clearError deve limpar mensagem', () {
      final state = BiometricState(errorMessage: 'erro');
      final copy = state.copyWith(clearError: true);
      expect(copy.errorMessage, isNull);
    });
  });
}
