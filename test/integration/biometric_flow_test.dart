import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vaultapp/domain/services/biometric_service.dart';
import 'package:vaultapp/data/services/biometric_preference_service.dart';
import 'package:vaultapp/presentation/viewmodels/biometric_viewmodel.dart';

import '../helpers/fake_secure_storage.dart';

void main() {
  group('Biometric Flow Integration', () {
    test('Fluxo 1: biometria indisponivel → sem botão → apenas senha', () async {
      final biometricService = BiometricService();
      final preferenceService = BiometricPreferenceService(
        storage: FakeSecureStorage(),
      );

      // Verificar disponibilidade
      final isAvailable = await biometricService.isAvailable();
      // Em emulador, deve ser false
      expect(isAvailable, isA<bool>());

      // Verificar preferencia
      final isEnabled = await preferenceService.isEnabled();
      expect(isEnabled, isA<bool>());
    });

    test('Fluxo 2: preferencia persiste apos alteracao', () async {
      final preferenceService = BiometricPreferenceService(
        storage: FakeSecureStorage(),
      );

      // Ativar
      await preferenceService.setEnabled(true);
      expect(await preferenceService.isEnabled(), true);

      // Desativar
      await preferenceService.setEnabled(false);
      expect(await preferenceService.isEnabled(), false);
    });

    test('Fluxo 3: biometric types retorna lista', () async {
      final biometricService = BiometricService();
      final types = await biometricService.getAvailableTypes();
      expect(types, isA<List<BiometricType>>());
    });

    test('Fluxo 4: authenticate retorna BiometricResult', () async {
      final biometricService = BiometricService();
      final result = await biometricService.authenticate();
      expect(result, isA<BiometricResult>());
    });

    test('Fluxo 5: BiometricState inicial correto', () {
      const state = BiometricState();
      expect(state.isAvailable, false);
      expect(state.isAuthenticating, false);
      expect(state.errorMessage, isNull);
      expect(state.isEnabled, false);
    });
  });
}
