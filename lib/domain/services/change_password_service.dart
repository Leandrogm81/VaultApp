import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/daos/password_dao.dart';
import '../../data/database/app_database.dart';
import '../../data/services/secure_storage_service.dart';
import 'crypto_service.dart';

/// Excecao lancada quando a senha atual fornecida e incorreta.
class InvalidCurrentPasswordException implements Exception {
  const InvalidCurrentPasswordException();
  @override
  String toString() => 'Senha atual incorreta.';
}

/// Excecao lancada quando a alteracao de senha falha.
class ChangePasswordFailedException implements Exception {
  final String message;
  const ChangePasswordFailedException(this.message);
  @override
  String toString() => message;
}

/// Servico para alteracao segura da senha mestra.
///
/// Orquestra o fluxo completo: validar senha atual, gerar novo salt,
/// derivar nova chave, re-criptografar todos os dados sensiveis,
/// e atualizar salt/chave no Secure Storage. Inclui rollback em caso de falha.
class ChangePasswordService {
  final CryptoService _crypto;
  final PasswordDao _passwordDao;
  final SecureStorageService _storage;

  /// Chave derivada da senha antiga (usada para descriptografar).
  Uint8List? _oldKey;

  /// Chave derivada da nova senha (usada para re-criptografar).
  Uint8List? _newKey;

  ChangePasswordService({
    required CryptoService crypto,
    required PasswordDao passwordDao,
    required FlutterSecureStorage? secureStorage,
  })  : _crypto = crypto,
        _passwordDao = passwordDao,
        _storage = SecureStorageService(storage: secureStorage);

  /// Armazenamento seguro (acessivel para testes e configuracao externa).
  SecureStorageService get storage => _storage;

  /// Valida se a senha atual fornecida esta correta.
  ///
  /// Deriva a chave a partir da senha e do salt armazenado,
  /// e verifica se descriptografa o verifier corretamente.
  Future<bool> validateCurrentPassword(String currentPassword) async {
    final salt = await _storage.getSalt();
    if (salt == null) return false;

    final key = await _crypto.deriveKey(currentPassword, salt);
    final verifier = await _storage.getVerifier();
    if (verifier == null) return false;

    try {
      final plaintext = await _crypto.decrypt(
        key,
        verifier.ciphertext,
        verifier.nonce,
        verifier.tag,
      );
      final recovered = String.fromCharCodes(plaintext);
      return recovered == 'vault_verifier';
    } catch (e) {
      return false;
    }
  }

  /// Altera a senha mestra e re-criptografa todos os dados sensiveis.
  ///
  /// Fluxo:
  /// 1. Valida senha atual
  /// 2. Gera novo salt e deriva nova chave
  /// 3. Faz backup dos dados atuais
  /// 4. Re-criptografa todos os campos password e notes
  /// 5. Atualiza salt e chave no Secure Storage
  ///
  /// Em caso de falha, restaura o backup e lança exceção.
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    // 1. Validar senha atual
    final isValid = await validateCurrentPassword(currentPassword);
    if (!isValid) {
      throw const InvalidCurrentPasswordException();
    }

    // 2. Obter chave antiga e salt atual
    final oldSalt = await _storage.getSalt();
    if (oldSalt == null) {
      throw const ChangePasswordFailedException(
        'Salt nao encontrado no Secure Storage.',
      );
    }
    _oldKey = await _crypto.deriveKey(currentPassword, oldSalt);

    // 3. Gerar novo salt e derivar nova chave
    final newSalt = await _crypto.generateSalt();
    _newKey = await _crypto.deriveKey(newPassword, newSalt);

    // 4. Fazer backup antes de alterar
    final backup = await createBackup();

    try {
      // 5. Re-criptografar todos os registros
      await _reEncryptAllPasswords();

      // 6. Atualizar salt e chave no Secure Storage
      await _storage.saveSalt(newSalt);
      await _storage.saveKey(_newKey!);

      // 7. Re-criptografar verifier com nova chave
      final verifierResult = await _crypto.encrypt(
        _newKey!,
        Uint8List.fromList('vault_verifier'.codeUnits),
      );
      await _storage.saveVerifier(
        ciphertext: verifierResult.ciphertext,
        nonce: verifierResult.nonce,
        tag: verifierResult.tag,
      );

      return true;
    } catch (e) {
      // 7. Em caso de falha, restaurar backup
      await restoreBackup(backup);
      throw ChangePasswordFailedException(
        'Falha ao alterar senha: ${e.toString()}',
      );
    }
  }

  /// Re-criptografa todos os campos password e notes no banco.
  ///
  /// Para cada registro: descriptografa com chave antiga, re-criptografa
  /// com chave nova. Se qualquer operacao falhar, lanca excecao.
  Future<void> _reEncryptAllPasswords() async {
    final allPasswords = await _passwordDao.getAll();

    for (final entry in allPasswords) {
      // Re-criptografar password
      final newEncryptedPassword = await _reEncryptField(
        entry.password,
        _oldKey!,
        _newKey!,
      );

      // Re-criptografar notes (se existir)
      String? newEncryptedNotes;
      if (entry.notes != null && entry.notes!.isNotEmpty) {
        newEncryptedNotes = await _reEncryptField(
          entry.notes!,
          _oldKey!,
          _newKey!,
        );
      }

      // Atualizar registro no banco
      await _passwordDao.updatePassword(
        PasswordsTableCompanion(
          id: Value(entry.id),
          categoryId: Value(entry.categoryId),
          title: Value(entry.title),
          username: Value(entry.username),
          password: Value(newEncryptedPassword),
          url: Value(entry.url),
          notes: Value(newEncryptedNotes),
          tags: Value(entry.tags),
          favorite: Value(entry.favorite),
          createdAt: Value(entry.createdAt),
          updatedAt: Value(entry.updatedAt),
        ),
      );
    }
  }

  /// Re-criptografa um campo individual: descriptografa com oldKey,
  /// re-criptografa com newKey.
  ///
  /// Formato armazenado: 'ciphertext_hex:nonce_hex:tag_hex'
  /// Se o campo nao estiver no formato esperado, retorna-o sem alteracao.
  Future<String> _reEncryptField(
    String encryptedField,
    Uint8List oldKey,
    Uint8List newKey,
  ) async {
    final parts = encryptedField.split(':');
    if (parts.length != 3) {
      // Campo nao esta no formato criptografado — retorna sem alteracao
      return encryptedField;
    }

    try {
      final ciphertext = _decodeHex(parts[0]);
      final nonce = _decodeHex(parts[1]);
      final tag = _decodeHex(parts[2]);

      // Descriptografar com chave antiga
      final plaintext = await _crypto.decrypt(oldKey, ciphertext, nonce, tag);

      // Re-criptografar com chave nova
      final result = await _crypto.encrypt(newKey, plaintext);

      // Serializar no formato: 'ciphertext_hex:nonce_hex:tag_hex'
      return '${_encodeHex(result.ciphertext)}:'
          '${_encodeHex(result.nonce)}:'
          '${_encodeHex(result.tag)}';
    } catch (e) {
      throw ChangePasswordFailedException(
        'Falha ao re-criptografar campo: ${e.toString()}',
      );
    }
  }

  /// Cria um backup dos dados atuais para uso em caso de falha.
  ///
  /// Retorna uma copia da lista de registros do banco.
  Future<List<PasswordsTableData>> createBackup() async {
    final allPasswords = await _passwordDao.getAll();
    // Retorna copia da lista (objetos sao imutaveis em Dart)
    return List<PasswordsTableData>.from(allPasswords);
  }

  /// Restaura o backup: descriptografa dados re-criptografados e
  /// re-criptografa com a chave antiga para recuperar o estado original.
  ///
  /// Usado quando a re-criptografia falha no meio do processo.
  Future<void> restoreBackup(List<PasswordsTableData> backup) async {
    if (_oldKey == null || _newKey == null) return;

    for (final entry in backup) {
      // Descriptografar com nova chave e re-criptografar com antiga
      final restoredPassword = await _reEncryptField(
        entry.password,
        _newKey!,
        _oldKey!,
      );

      String? restoredNotes;
      if (entry.notes != null && entry.notes!.isNotEmpty) {
        restoredNotes = await _reEncryptField(
          entry.notes!,
          _newKey!,
          _oldKey!,
        );
      }

      await _passwordDao.updatePassword(
        PasswordsTableCompanion(
          id: Value(entry.id),
          categoryId: Value(entry.categoryId),
          title: Value(entry.title),
          username: Value(entry.username),
          password: Value(restoredPassword),
          url: Value(entry.url),
          notes: Value(restoredNotes),
          tags: Value(entry.tags),
          favorite: Value(entry.favorite),
          createdAt: Value(entry.createdAt),
          updatedAt: Value(entry.updatedAt),
        ),
      );
    }

    // Restaurar salt e chave antigos
    final oldSalt = await _storage.getSalt();
    if (oldSalt != null && _oldKey != null) {
      await _storage.saveKey(_oldKey!);
    }
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
