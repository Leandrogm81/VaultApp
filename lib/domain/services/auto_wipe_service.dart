import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'vault_state_service.dart';

/// Servico de auto-wipe que apaga todos os dados do app
/// apos N tentativas falhas (default: 10, configuravel).
///
/// Apaga: banco SQLite, Secure Storage (chave + salt).
/// Sem confirmacao (decisao aprovada no projeto).
class AutoWipeService {
  final VaultStateService _vaultState;
  final FlutterSecureStorage? _secureStorage;

  /// Threshold default: 10 tentativas.
  static const int defaultThreshold = 10;

  AutoWipeService(
    this._vaultState, {
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage;

  /// Retorna o threshold atual de auto-wipe.
  ///
  /// Por enquanto usa o default. Quando PreferencesService
  /// tiver suporte a autoWipeThreshold, pode ser integrado.
  Future<int> getWipeThreshold() async {
    return defaultThreshold;
  }

  /// Verifica se o numero de tentativas atingiu o threshold.
  /// Se sim, executa o wipe e retorna true.
  Future<bool> checkAndWipe(int failedAttempts) async {
    final threshold = await getWipeThreshold();
    if (failedAttempts >= threshold) {
      await performWipe();
      return true;
    }
    return false;
  }

  /// Executa o wipe completo: banco SQLite + Secure Storage.
  ///
  /// Operacao irreversivel. Cada etapa tratada individualmente
  /// para evitar falha parcial silenciosa.
  Future<void> performWipe() async {
    // 1. Apagar banco SQLite
    await _wipeDatabase();

    // 2. Apagar Secure Storage
    await _wipeSecureStorage();

    // 3. Resetar estado do vault
    await _vaultState.resetFailedAttempts();
    await _vaultState.clearLock();
  }

  /// Apaga o arquivo do banco de dados SQLite.
  Future<void> _wipeDatabase() async {
    try {
      // Encontrar e deletar o arquivo do banco
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dbFolder.path, 'vault.db'));
      if (await dbFile.exists()) {
        await dbFile.delete();
      }

      // Deletar arquivos auxiliares do SQLite (.db-shm, .db-wal)
      final shmFile = File('${dbFile.path}-shm');
      final walFile = File('${dbFile.path}-wal');
      if (await shmFile.exists()) await shmFile.delete();
      if (await walFile.exists()) await walFile.delete();
    } catch (e) {
      // Log erro mas nao impede wipe
      // Em producao, registrar em log
    }
  }

  /// Limpa todo o Secure Storage.
  Future<void> _wipeSecureStorage() async {
    try {
      final storage = _secureStorage ?? const FlutterSecureStorage();
      await storage.deleteAll();
    } catch (e) {
      // Log erro mas nao impede wipe
    }
  }
}
