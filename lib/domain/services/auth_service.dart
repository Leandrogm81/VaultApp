import 'dart:typed_data';

import '../services/crypto_service.dart';
import '../../data/services/secure_storage_service.dart';

/// Resultado de uma operacao de autenticacao.
sealed class AuthResult {
  const AuthResult();
}

/// Autenticacao bem-sucedida com a chave derivada.
class AuthSuccess extends AuthResult {
  final Uint8List key;
  const AuthSuccess(this.key);
}

/// Autenticacao falhou (senha incorreta).
class AuthFailure extends AuthResult {
  const AuthFailure();
}

/// Servico de autenticacao por senha mestra.
///
/// Orquestra o fluxo completo: senha -> salt -> chave -> validacao.
/// Usa CryptoService para derivacao de chave e SecureStorageService
/// para armazenamento de salt, chave e verifier.
class AuthService {
  final CryptoService _crypto;
  final SecureStorageService _storage;

  /// Texto fixo criptografado para validar a senha.
  static const String _verifierPlaintext = 'vault_verifier';

  AuthService({
    required CryptoService crypto,
    required SecureStorageService storage,
  })  : _crypto = crypto,
        _storage = storage;

  /// Configura a senha mestra pela primeira vez.
  ///
  /// Gera salt, deriva chave, salva no SecureStorage e cria verifier.
  Future<void> setupPassword(String password) async {
    // Gerar salt
    final salt = await _crypto.generateSalt();

    // Derivar chave
    final key = await _crypto.deriveKey(password, salt);

    // Salvar salt e chave
    await _storage.saveSalt(salt);
    await _storage.saveKey(key);

    // Criar verifier: encrypt do plaintext fixo
    final result = await _crypto.encrypt(
      key,
      Uint8List.fromList(_verifierPlaintext.codeUnits),
    );

    // Salvar verifier
    await _storage.saveVerifier(
      ciphertext: result.ciphertext,
      nonce: result.nonce,
      tag: result.tag,
    );
  }

  /// Autentica o usuario com a senha fornecida.
  ///
  /// Recupera salt, deriva chave e tenta descriptografar o verifier.
  Future<AuthResult> authenticate(String password) async {
    // Recuperar salt
    final salt = await _storage.getSalt();
    if (salt == null) return const AuthFailure();

    // Derivar chave
    final key = await _crypto.deriveKey(password, salt);

    // Recuperar verifier
    final verifier = await _storage.getVerifier();
    if (verifier == null) return const AuthFailure();

    // Tentar descriptografar
    try {
      final plaintext = await _crypto.decrypt(
        key,
        verifier.ciphertext,
        verifier.nonce,
        verifier.tag,
      );

      // Verificar se o plaintext corresponde ao verifier
      final recovered = String.fromCharCodes(plaintext);
      if (recovered == _verifierPlaintext) {
        return AuthSuccess(key);
      }
      return const AuthFailure();
    } catch (e) {
      return const AuthFailure();
    }
  }

  /// Verifica se e a primeira vez (nao ha salt salvo).
  Future<bool> isFirstTime() async {
    return !(await _storage.hasSalt());
  }
}
