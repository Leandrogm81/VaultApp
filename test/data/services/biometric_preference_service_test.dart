import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/services/biometric_preference_service.dart';

import '../../helpers/fake_secure_storage.dart';

void main() {
  late BiometricPreferenceService service;

  setUp(() {
    service = BiometricPreferenceService(storage: FakeSecureStorage());
  });

  group('BiometricPreferenceService', () {
    test('isEnabled deve retornar false por padrao', () async {
      final result = await service.isEnabled();
      expect(result, false);
    });

    test('setEnabled(true) deve persistir corretamente', () async {
      await service.setEnabled(true);
      final result = await service.isEnabled();
      expect(result, true);
    });

    test('setEnabled(false) deve persistir corretamente', () async {
      await service.setEnabled(true);
      await service.setEnabled(false);
      final result = await service.isEnabled();
      expect(result, false);
    });

    test('hasSeenBiometricPrompt deve retornar false por padrao', () async {
      final result = await service.hasSeenBiometricPrompt();
      expect(result, false);
    });

    test('setSeenBiometricPrompt deve persistir corretamente', () async {
      await service.setSeenBiometricPrompt();
      final result = await service.hasSeenBiometricPrompt();
      expect(result, true);
    });
  });
}
