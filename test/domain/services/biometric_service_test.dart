import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vaultapp/domain/services/biometric_service.dart';

void main() {
  // NOTA: Estes testes requerem device/emulator real para local_auth.
  // Em ambiente de teste unitario, local_auth retorna false para canCheckBiometrics.

  group('BiometricService', () {
    late BiometricService service;

    setUp(() {
      service = BiometricService();
    });

    test('isAvailable deve retornar bool', () async {
      final result = await service.isAvailable();
      expect(result, isA<bool>());
    });

    test('getAvailableTypes deve retornar lista', () async {
      final result = await service.getAvailableTypes();
      expect(result, isA<List<BiometricType>>());
    });

    test('authenticate deve retornar BiometricResult', () async {
      final result = await service.authenticate();
      expect(result, isA<BiometricResult>());
    });

    test('BiometricSuccess deve ser BiometricResult', () {
      const result = BiometricSuccess();
      expect(result, isA<BiometricResult>());
    });

    test('BiometricFailure deve conter reason', () {
      const result = BiometricFailure('motivo');
      expect(result.reason, 'motivo');
    });

    test('BiometricUnavailable deve ser BiometricResult', () {
      const result = BiometricUnavailable();
      expect(result, isA<BiometricResult>());
    });
  });
}
