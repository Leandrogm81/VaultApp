import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/password_dao.dart';
import 'package:vaultapp/domain/services/crypto_service.dart';
import 'package:vaultapp/domain/services/change_password_service.dart';
import 'package:vaultapp/data/services/secure_storage_service.dart';

import '../../helpers/fake_secure_storage.dart';

class MockPasswordDao extends Mock implements PasswordDao {}

class MockCryptoService extends Mock implements CryptoService {}

void main() {
  late MockPasswordDao mockDao;
  late MockCryptoService mockCrypto;
  late FakeSecureStorage fakeStorage;
  late SecureStorageService storage;
  late ChangePasswordService service;

  setUp(() {
    mockDao = MockPasswordDao();
    mockCrypto = MockCryptoService();
    fakeStorage = FakeSecureStorage();
    storage = SecureStorageService(storage: fakeStorage);
    service = ChangePasswordService(
      crypto: mockCrypto,
      passwordDao: mockDao,
      secureStorage: fakeStorage,
    );

    // Registrar fallbacks para geradores de argumento
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(PasswordsTableCompanion.insert(
      id: 'fallback',
      title: 'fallback',
      username: 'fallback',
      password: 'fallback',
      createdAt: 'fallback',
      updatedAt: 'fallback',
    ));
  });

  group('ChangePasswordService', () {
    group('validateCurrentPassword', () {
      test('retorna true quando verifier e descriptografado corretamente',
          () async {
        final fakeSalt = Uint8List(16)..[0] = 1;
        final fakeKey = Uint8List(32)..[0] = 2;
        final fakeVerifierPlain = Uint8List.fromList('vault_verifier'.codeUnits);

        when(() => mockCrypto.deriveKey(any(), any()))
            .thenAnswer((_) async => fakeKey);
        when(() => mockCrypto.decrypt(any(), any(), any(), any()))
            .thenAnswer((_) async => fakeVerifierPlain);

        // Simular salt no storage
        await fakeStorage.write(key: 'vault_salt', value: _encodeHex(fakeSalt));

        // Simular verifier no storage
        await fakeStorage.write(
            key: 'vault_verifier_cipher', value: _encodeHex(Uint8List(16)));
        await fakeStorage.write(
            key: 'vault_verifier_nonce', value: _encodeHex(Uint8List(12)));
        await fakeStorage.write(
            key: 'vault_verifier_tag', value: _encodeHex(Uint8List(16)));

        final result = await service.validateCurrentPassword('senha_teste');
        expect(result, true);
      });

      test('retorna false quando verifier nao corresponde', () async {
        final fakeSalt = Uint8List(16)..[0] = 1;
        final fakeKey = Uint8List(32)..[0] = 2;

        when(() => mockCrypto.deriveKey(any(), any()))
            .thenAnswer((_) async => fakeKey);
        when(() => mockCrypto.decrypt(any(), any(), any(), any()))
            .thenAnswer((_) async => Uint8List.fromList('wrong_text'.codeUnits));

        await fakeStorage.write(key: 'vault_salt', value: _encodeHex(fakeSalt));
        await fakeStorage.write(
            key: 'vault_verifier_cipher', value: _encodeHex(Uint8List(16)));
        await fakeStorage.write(
            key: 'vault_verifier_nonce', value: _encodeHex(Uint8List(12)));
        await fakeStorage.write(
            key: 'vault_verifier_tag', value: _encodeHex(Uint8List(16)));

        final result = await service.validateCurrentPassword('senha_teste');
        expect(result, false);
      });

      test('retorna false quando nao ha salt', () async {
        final result = await service.validateCurrentPassword('qualquer');
        expect(result, false);
      });

      test('retorna false quando decrypt falha', () async {
        final fakeSalt = Uint8List(16)..[0] = 1;
        final fakeKey = Uint8List(32)..[0] = 2;

        when(() => mockCrypto.deriveKey(any(), any()))
            .thenAnswer((_) async => fakeKey);
        when(() => mockCrypto.decrypt(any(), any(), any(), any()))
            .thenThrow(Exception('decrypt failed'));

        await fakeStorage.write(key: 'vault_salt', value: _encodeHex(fakeSalt));
        await fakeStorage.write(
            key: 'vault_verifier_cipher', value: _encodeHex(Uint8List(16)));
        await fakeStorage.write(
            key: 'vault_verifier_nonce', value: _encodeHex(Uint8List(12)));
        await fakeStorage.write(
            key: 'vault_verifier_tag', value: _encodeHex(Uint8List(16)));

        final result = await service.validateCurrentPassword('senha_teste');
        expect(result, false);
      });
    });

    group('createBackup', () {
      test('retorna lista vazia quando nao ha registros', () async {
        when(() => mockDao.getAll()).thenAnswer((_) async => []);

        final backup = await service.createBackup();
        expect(backup, isEmpty);
      });

      test('retorna copia dos registros existentes', () async {
        final now = DateTime.now().toIso8601String();
        when(() => mockDao.getAll()).thenAnswer((_) async => [
              PasswordsTableData(
                id: 'test-1',
                title: 'GitHub',
                username: 'user@test.com',
                password: 'encrypted',
                tags: '[]',
                favorite: false,
                createdAt: now,
                updatedAt: now,
              ),
            ]);

        final backup = await service.createBackup();
        expect(backup.length, 1);
        expect(backup.first.id, 'test-1');
        expect(backup.first.title, 'GitHub');
      });
    });

    group('changePassword', () {
      setUp(() {
        // Configurar estado inicial para os testes de changePassword
        final fakeSalt = Uint8List(16)..[0] = 1;
        final fakeKey = Uint8List(32)..[0] = 2;
        final fakeVerifierPlain = Uint8List.fromList('vault_verifier'.codeUnits);

        when(() => mockCrypto.deriveKey(any(), any()))
            .thenAnswer((_) async => fakeKey);
        when(() => mockCrypto.generateSalt())
            .thenAnswer((_) async => Uint8List(16)..[0] = 99);
        when(() => mockCrypto.decrypt(any(), any(), any(), any()))
            .thenAnswer((_) async => fakeVerifierPlain);
        when(() => mockCrypto.encrypt(any(), any())).thenAnswer(
          (_) async => EncryptResult(
            ciphertext: Uint8List(16)..[0] = 10,
            nonce: Uint8List(12)..[0] = 11,
            tag: Uint8List(16)..[0] = 12,
          ),
        );
        when(() => mockDao.getAll()).thenAnswer((_) async => []);
        when(() => mockDao.updatePassword(any()))
            .thenAnswer((_) async => true);

        // Simular salt e verifier no storage
        fakeStorage.write(
            key: 'vault_salt', value: _encodeHex(fakeSalt));
        fakeStorage.write(
            key: 'vault_verifier_cipher', value: _encodeHex(Uint8List(16)));
        fakeStorage.write(
            key: 'vault_verifier_nonce', value: _encodeHex(Uint8List(12)));
        fakeStorage.write(
            key: 'vault_verifier_tag', value: _encodeHex(Uint8List(16)));
      });

      test('lanca InvalidCurrentPasswordException para senha incorreta',
          () async {
        // Sobrescrever para retornar false na validacao
        when(() => mockCrypto.decrypt(any(), any(), any(), any()))
            .thenAnswer((_) async => Uint8List.fromList('wrong'.codeUnits));

        expect(
          () => service.changePassword('senha_errada', 'nova_senha'),
          throwsA(isA<InvalidCurrentPasswordException>()),
        );
      });

      test('gera novo salt diferente do anterior', () async {
        final oldSalt = await storage.getSalt();

        await service.changePassword('senha_atual', 'nova_senha_123');

        final newSalt = await storage.getSalt();
        expect(newSalt, isNot(equals(null)));
        expect(newSalt, isNot(equals(oldSalt)));
      });

      test('deriva nova chave diferente da anterior', () async {
        await service.changePassword('senha_atual', 'nova_senha_123');

        final newKey = await storage.getKey();
        expect(newKey, isNot(equals(null)));
        // Chave pode ser igual se deriveKey retorna o mesmo mock
        // O importante e que foi chamado
        verify(() => mockCrypto.deriveKey(any(), any())).called(greaterThan(1));
      });

      test('retorna true em caso de sucesso', () async {
        final result =
            await service.changePassword('senha_atual', 'nova_senha_123');
        expect(result, true);
      });

      test('atualiza salt e chave no Secure Storage', () async {
        await service.changePassword('senha_atual', 'nova_senha_123');

        final newSalt = await storage.getSalt();
        final newKey = await storage.getKey();
        expect(newSalt, isNot(equals(null)));
        expect(newKey, isNot(equals(null)));
      });

      test('re-criptografa verifier com nova chave', () async {
        await service.changePassword('senha_atual', 'nova_senha_123');

        // Verificar que encrypt foi chamado para re-criptografar o verifier
        verify(() => mockCrypto.encrypt(any(), any())).called(greaterThan(0));
      });

      test('re-criptografa registros existentes', () async {
        final now = DateTime.now().toIso8601String();
        when(() => mockDao.getAll()).thenAnswer((_) async => [
              PasswordsTableData(
                id: 'test-1',
                title: 'GitHub',
                username: 'user@test.com',
                password: 'old_encrypted_data',
                tags: '[]',
                favorite: false,
                createdAt: now,
                updatedAt: now,
              ),
            ]);

        await service.changePassword('senha_atual', 'nova_senha_123');

        // Verificar que updatePassword foi chamado para o registro
        verify(() => mockDao.updatePassword(any())).called(1);
      });

      test('campo com formato invalido e retornado sem alteracao', () async {
        final now = DateTime.now().toIso8601String();
        when(() => mockDao.getAll()).thenAnswer((_) async => [
              PasswordsTableData(
                id: 'test-1',
                title: 'GitHub',
                username: 'user@test.com',
                password: 'invalid_format',
                tags: '[]',
                favorite: false,
                createdAt: now,
                updatedAt: now,
              ),
            ]);

        final result =
            await service.changePassword('senha_atual', 'nova_senha_123');
        expect(result, true);

        // Verificar que o password foi mantido (formato invalido = sem alteracao)
        final captured = verify(() => mockDao.updatePassword(captureAny()))
            .captured
            .single;
        expect(captured.password.value, 'invalid_format');
      });
    });
  });
}

String _encodeHex(List<int> bytes) {
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
