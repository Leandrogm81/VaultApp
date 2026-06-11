import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Servico de criptografia para o VaultApp.
///
/// Gera salt aleatorio, deriva chave AES-256 via Argon2id,
/// e fornece encrypt/decrypt com AES-256-GCM.
class CryptoService {
  /// Algoritmo Argon2id para derivacao de chave.
  static final Argon2id _argon2id = Argon2id(
    memory: 65536, // 64 MB
    iterations: 3,
    parallelism: 4,
    hashLength: 32, // 256 bits = AES-256
  );

  /// Gera salt aleatorio de 16 bytes.
  Future<Uint8List> generateSalt() async {
    // Gerar 16 bytes aleatorios seguros via AesGcm nonce + Sha256
    final algorithm = AesGcm.with256bits();
    final nonce1 = algorithm.newNonce();
    final nonce2 = algorithm.newNonce();
    // Combinar dois nonces e hash para gerar 16 bytes
    final combined = [...nonce1, ...nonce2];
    final hash = await Sha256().hash(combined);
    return Uint8List.fromList(hash.bytes.sublist(0, 16));
  }

  /// Deriva chave AES-256 (32 bytes) de uma senha e salt usando Argon2id.
  Future<Uint8List> deriveKey(String password, Uint8List salt) async {
    final secretBox = await _argon2id.deriveKey(
      secretKey: SecretKey(Uint8List.fromList(password.codeUnits)),
      nonce: salt,
    );
    final bytes = await secretBox.extractBytes();
    return Uint8List.fromList(bytes);
  }

  /// Criptografa dados com AES-256-GCM.
  /// Retorna [EncryptResult] contendo ciphertext, nonce e tag.
  Future<EncryptResult> encrypt(Uint8List key, Uint8List plaintext) async {
    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encrypt(
      plaintext,
      secretKey: SecretKey(key),
    );
    return EncryptResult(
      ciphertext: Uint8List.fromList(secretBox.cipherText),
      nonce: Uint8List.fromList(secretBox.nonce),
      tag: Uint8List.fromList(secretBox.mac.bytes),
    );
  }

  /// Descriptografa dados com AES-256-GCM.
  Future<Uint8List> decrypt(
    Uint8List key,
    Uint8List ciphertext,
    Uint8List nonce,
    Uint8List tag,
  ) async {
    final algorithm = AesGcm.with256bits();
    final secretBox = SecretBox(
      ciphertext,
      nonce: nonce,
      mac: Mac(tag),
    );
    return Uint8List.fromList(
      await algorithm.decrypt(secretBox, secretKey: SecretKey(key)),
    );
  }
}

/// Resultado de uma operacao de criptografia.
class EncryptResult {
  /// Dados criptografados.
  final Uint8List ciphertext;

  /// Nonce usado na criptografia (12 bytes).
  final Uint8List nonce;

  /// Tag de autenticacao GCM (16 bytes).
  final Uint8List tag;

  const EncryptResult({
    required this.ciphertext,
    required this.nonce,
    required this.tag,
  });
}
