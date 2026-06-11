import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/domain/services/auth_service.dart';
import 'package:vaultapp/domain/services/crypto_service.dart';
import 'package:vaultapp/data/services/secure_storage_service.dart';

import '../../helpers/fake_secure_storage.dart';

void main() {
  late AuthService authService;
  late CryptoService crypto;
  late SecureStorageService storage;

  setUp(() {
    crypto = CryptoService();
    storage = SecureStorageService(storage: FakeSecureStorage());
    authService = AuthService(crypto: crypto, storage: storage);
  });

  group('AuthService', () {
    test('isFirstTime deve retornar inicialmente true', () async {
      final result = await authService.isFirstTime();
      expect(result, true);
    });

    test('setupPassword deve criar salt e verifier', () async {
      await authService.setupPassword('minha_senha');

      final hasSalt = await storage.hasSalt();
      expect(hasSalt, true);

      final verifier = await storage.getVerifier();
      expect(verifier, isNotNull);
    });

    test('isFirstTime deve retornar false apos setupPassword', () async {
      await authService.setupPassword('minha_senha');
      final result = await authService.isFirstTime();
      expect(result, false);
    });

    test('authenticate com senha correta deve retornar AuthSuccess', () async {
      await authService.setupPassword('minha_senha');
      final result = await authService.authenticate('minha_senha');
      expect(result, isA<AuthSuccess>());
    });

    test('authenticate com senha errada deve retornar AuthFailure', () async {
      await authService.setupPassword('minha_senha');
      final result = await authService.authenticate('senha_errada');
      expect(result, isA<AuthFailure>());
    });

    test('authenticate sem setup deve retornar AuthFailure', () async {
      final result = await authService.authenticate('qualquer');
      expect(result, isA<AuthFailure>());
    });

    test('AuthSuccess deve conter chave de 32 bytes', () async {
      await authService.setupPassword('minha_senha');
      final result = await authService.authenticate('minha_senha');
      expect(result, isA<AuthSuccess>());
      final success = result as AuthSuccess;
      expect(success.key.length, 32);
    });
  });
}
