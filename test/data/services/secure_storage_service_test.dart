import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/services/secure_storage_service.dart';

import '../../helpers/fake_secure_storage.dart';

void main() {
  late SecureStorageService service;
  late FakeSecureStorage fakeStorage;

  setUp(() {
    fakeStorage = FakeSecureStorage();
    service = SecureStorageService(storage: fakeStorage);
  });

  group('SecureStorageService', () {
    test('hasSalt deve retornar false quando nao ha salt', () async {
      final result = await service.hasSalt();
      expect(result, false);
    });

    test('getSalt deve retornar null quando nao ha salt', () async {
      final result = await service.getSalt();
      expect(result, isNull);
    });

    test('getKey deve retornar null quando nao ha chave', () async {
      final result = await service.getKey();
      expect(result, isNull);
    });

    test('saveSalt e getSalt devem ser invertiveis', () async {
      final salt = Uint8List.fromList([
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
      ]);
      await service.saveSalt(salt);
      final retrieved = await service.getSalt();
      expect(retrieved, equals(salt));
    });

    test('saveKey e getKey devem ser invertiveis', () async {
      final key = Uint8List(32); // 32 bytes zeros
      await service.saveKey(key);
      final retrieved = await service.getKey();
      expect(retrieved, equals(key));
    });

    test('hasSalt deve retornar true apos saveSalt', () async {
      final salt = Uint8List.fromList([
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
      ]);
      await service.saveSalt(salt);
      final result = await service.hasSalt();
      expect(result, true);
    });

    test('deleteAll deve remover salt e chave', () async {
      final salt = Uint8List.fromList([
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
      ]);
      final key = Uint8List(32);
      await service.saveSalt(salt);
      await service.saveKey(key);

      await service.deleteAll();

      expect(await service.getSalt(), isNull);
      expect(await service.getKey(), isNull);
      expect(await service.hasSalt(), false);
    });

    test('saveVerifier e getVerifier devem ser invertiveis', () async {
      final ciphertext = Uint8List.fromList([10, 20, 30]);
      final nonce = Uint8List.fromList([40, 50, 60]);
      final tag = Uint8List.fromList([70, 80, 90]);

      await service.saveVerifier(
        ciphertext: ciphertext,
        nonce: nonce,
        tag: tag,
      );

      final verifier = await service.getVerifier();
      expect(verifier, isNotNull);
      expect(verifier!.ciphertext, equals(ciphertext));
      expect(verifier.nonce, equals(nonce));
      expect(verifier.tag, equals(tag));
    });

    test('getVerifier deve retornar null quando nao existe', () async {
      final result = await service.getVerifier();
      expect(result, isNull);
    });
  });
}
