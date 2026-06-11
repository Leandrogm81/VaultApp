import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servico de armazenamento seguro para salt, chave AES e verifier.
///
/// Usa flutter_secure_storage para persistir dados sensiveis.
/// Dados sao serializados como hex para armazenamento.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  /// Chaves de armazenamento.
  static const String _saltKey = 'vault_salt';
  static const String _keyKey = 'vault_key';
  static const String _verifierCipherKey = 'vault_verifier_cipher';
  static const String _verifierNonceKey = 'vault_verifier_nonce';
  static const String _verifierTagKey = 'vault_verifier_tag';

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Salva o salt (16 bytes) no Secure Storage.
  Future<void> saveSalt(Uint8List salt) async {
    await _storage.write(key: _saltKey, value: _encodeHex(salt));
  }

  /// Recupera o salt do Secure Storage. Retorna null se nao existe.
  Future<Uint8List?> getSalt() async {
    final hex = await _storage.read(key: _saltKey);
    if (hex == null) return null;
    return _decodeHex(hex);
  }

  /// Salva a chave AES (32 bytes) no Secure Storage.
  Future<void> saveKey(Uint8List key) async {
    await _storage.write(key: _keyKey, value: _encodeHex(key));
  }

  /// Recupera a chave AES do Secure Storage. Retorna null se nao existe.
  Future<Uint8List?> getKey() async {
    final hex = await _storage.read(key: _keyKey);
    if (hex == null) return null;
    return _decodeHex(hex);
  }

  /// Salva o verifier criptografado no Secure Storage.
  Future<void> saveVerifier({
    required Uint8List ciphertext,
    required Uint8List nonce,
    required Uint8List tag,
  }) async {
    await _storage.write(key: _verifierCipherKey, value: _encodeHex(ciphertext));
    await _storage.write(key: _verifierNonceKey, value: _encodeHex(nonce));
    await _storage.write(key: _verifierTagKey, value: _encodeHex(tag));
  }

  /// Recupera o verifier criptografado do Secure Storage.
  Future<VerifierData?> getVerifier() async {
    final cipherHex = await _storage.read(key: _verifierCipherKey);
    final nonceHex = await _storage.read(key: _verifierNonceKey);
    final tagHex = await _storage.read(key: _verifierTagKey);

    if (cipherHex == null || nonceHex == null || tagHex == null) return null;

    return VerifierData(
      ciphertext: _decodeHex(cipherHex),
      nonce: _decodeHex(nonceHex),
      tag: _decodeHex(tagHex),
    );
  }

  /// Remove todos os dados do Secure Storage.
  Future<void> deleteAll() async {
    await _storage.delete(key: _saltKey);
    await _storage.delete(key: _keyKey);
    await _storage.delete(key: _verifierCipherKey);
    await _storage.delete(key: _verifierNonceKey);
    await _storage.delete(key: _verifierTagKey);
  }

  /// Verifica se o salt existe.
  Future<bool> hasSalt() async {
    final hex = await _storage.read(key: _saltKey);
    return hex != null;
  }

  /// Serializa bytes para hexadecimal.
  static String _encodeHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Deserializa hexadecimal para bytes.
  static Uint8List _decodeHex(String hex) {
    final result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      result[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return result;
  }
}

/// Dados do verifier criptografado.
class VerifierData {
  final Uint8List ciphertext;
  final Uint8List nonce;
  final Uint8List tag;

  const VerifierData({
    required this.ciphertext,
    required this.nonce,
    required this.tag,
  });
}
