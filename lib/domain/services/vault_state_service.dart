import 'package:drift/drift.dart';

import '../../data/daos/vault_state_dao.dart';
import '../../data/database/app_database.dart';

/// Servico de persistencia para o estado de seguranca do vault.
///
/// Gerencia: contador de tentativas falhas, estado de bloqueio,
/// timestamp de desbloqueio. Leitura e escrita via VaultStateDAO.
class VaultStateService {
  final VaultStateDao _dao;

  VaultStateService(this._dao);

  /// Retorna o numero atual de tentativas falhas.
  Future<int> getFailedAttempts() async {
    final state = await _dao.get();
    return state?.failedAttempts ?? 0;
  }

  /// Incrementa o contador de tentativas falhas e retorna o novo valor.
  Future<int> incrementFailedAttempts() async {
    final current = await getFailedAttempts();
    final newValue = current + 1;
    await _upsertState(failedAttempts: newValue);
    return newValue;
  }

  /// Zera o contador de tentativas falhas.
  Future<void> resetFailedAttempts() async {
    await _upsertState(failedAttempts: 0);
  }

  /// Verifica se o vault esta bloqueado (lock_until > agora).
  Future<bool> isLocked() async {
    final state = await _dao.get();
    if (state == null || state.lockUntil == null) return false;

    final lockUntil = DateTime.tryParse(state.lockUntil!);
    if (lockUntil == null) return false;

    return DateTime.now().isBefore(lockUntil);
  }

  /// Define bloqueio ate um timestamp especifico.
  Future<void> setLocked(DateTime lockUntil) async {
    await _upsertState(
      locked: true,
      lockUntil: lockUntil.toIso8601String(),
    );
  }

  /// Remove o bloqueio (limpa lock_until e seta locked=false).
  Future<void> clearLock() async {
    await _upsertState(
      locked: false,
      lockUntil: null,
      clearLockUntil: true,
    );
  }

  /// Retorna o timestamp de desbloqueio, ou null se nao ha bloqueio.
  Future<DateTime?> getLockUntil() async {
    final state = await _dao.get();
    if (state?.lockUntil == null) return null;
    return DateTime.tryParse(state!.lockUntil!);
  }

  /// Upsert auxiliar para atualizar campos do estado.
  Future<void> _upsertState({
    int? failedAttempts,
    bool? locked,
    String? lockUntil,
    bool clearLockUntil = false,
  }) async {
    final existing = await _dao.get();
    await _dao.upsert(
      VaultStateTableCompanion(
        failedAttempts: Value(failedAttempts ?? existing?.failedAttempts ?? 0),
        locked: Value(
          locked != null
              ? (locked ? 'true' : 'false')
              : (existing?.locked ?? 'true'),
        ),
        lockUntil: clearLockUntil
            ? Value(null as String?)
            : Value(lockUntil ?? existing?.lockUntil),
      ),
    );
  }
}
