import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/domain/services/crypto_service.dart';

void main() {
  late CryptoService crypto;

  setUp(() {
    crypto = CryptoService();
  });

  group('CryptoService', () {
    test('generateSalt deve retornar 16 bytes', () async {
      final salt = await crypto.generateSalt();
      expect(salt.length, 16);
    });

    test('generateSalt deve retornar valores aleatorios', () async {
      final salt1 = await crypto.generateSalt();
      final salt2 = await crypto.generateSalt();
      expect(salt1, isNot(equals(salt2)));
    });

    test('deriveKey deve retornar 32 bytes (AES-256)', () async {
      final salt = await crypto.generateSalt();
      final key = await crypto.deriveKey('minha_senha', salt);
      expect(key.length, 32);
    });

    test('deriveKey com mesma senha + salt deve retornar mesma chave', () async {
      final salt = await crypto.generateSalt();
      final key1 = await crypto.deriveKey('minha_senha', salt);
      final key2 = await crypto.deriveKey('minha_senha', salt);
      expect(key1, equals(key2));
    });

    test('deriveKey com senhas diferentes deve retornar chaves diferentes', () async {
      final salt = await crypto.generateSalt();
      final key1 = await crypto.deriveKey('senha1', salt);
      final key2 = await crypto.deriveKey('senha2', salt);
      expect(key1, isNot(equals(key2)));
    });

    test('deriveKey com salts diferentes deve retornar chaves diferentes', () async {
      final salt1 = await crypto.generateSalt();
      final salt2 = await crypto.generateSalt();
      final key1 = await crypto.deriveKey('minha_senha', salt1);
      final key2 = await crypto.deriveKey('minha_senha', salt2);
      expect(key1, isNot(equals(key2)));
    });

    test('encrypt + decrypt devem ser invertiveis', () async {
      final salt = await crypto.generateSalt();
      final key = await crypto.deriveKey('minha_senha', salt);

      final plaintext = Uint8List.fromList('dados sensiveis'.codeUnits);
      final result = await crypto.encrypt(key, plaintext);

      expect(result.ciphertext.length, greaterThan(0));
      expect(result.nonce.length, greaterThan(0));
      expect(result.tag.length, greaterThan(0));

      final decrypted = await crypto.decrypt(
        key,
        result.ciphertext,
        result.nonce,
        result.tag,
      );
      expect(decrypted, equals(plaintext));
    });

    test('decrypt com chave errada deve falhar', () async {
      final salt = await crypto.generateSalt();
      final key1 = await crypto.deriveKey('senha1', salt);
      final key2 = await crypto.deriveKey('senha2', salt);

      final plaintext = Uint8List.fromList('dados'.codeUnits);
      final result = await crypto.encrypt(key1, plaintext);

      expect(
        () => crypto.decrypt(key2, result.ciphertext, result.nonce, result.tag),
        throwsA(anything),
      );
    });

    test('encrypt deve gerar nonce unico por operacao', () async {
      final salt = await crypto.generateSalt();
      final key = await crypto.deriveKey('minha_senha', salt);

      final plaintext = Uint8List.fromList('dados'.codeUnits);
      final result1 = await crypto.encrypt(key, plaintext);
      final result2 = await crypto.encrypt(key, plaintext);

      expect(result1.nonce, isNot(equals(result2.nonce)));
    });
  });
}
