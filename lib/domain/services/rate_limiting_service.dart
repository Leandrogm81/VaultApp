import 'vault_state_service.dart';

/// Resultado de uma operacao de rate limiting.
class RateLimitResult {
  /// Se o vault esta bloqueado.
  final bool isLocked;

  /// Numero de tentativas falhas.
  final int failedAttempts;

  /// Duracao do bloqueio em minutos (null se nao bloqueado).
  final int? lockDurationMinutes;

  /// Timestamp de desbloqueio (null se nao bloqueado).
  final DateTime? lockUntil;

  const RateLimitResult({
    required this.isLocked,
    required this.failedAttempts,
    this.lockDurationMinutes,
    this.lockUntil,
  });
}

/// Servico de rate limiting para protecao contra brute-force.
///
/// Controla tentativas de desbloqueio: apos N tentativas (default: 5),
/// aplica bloqueio progressivo (1min → 5min → 15min → 30min).
/// Conta tentativas e persiste entre sessoes via VaultStateService.
class RateLimitingService {
  final VaultStateService _vaultState;

  /// Numero maximo de tentativas antes do primeiro bloqueio.
  static const int maxAttempts = 5;

  /// Duracoes de bloqueio progressivo em minutos.
  /// Indice 0 = primeiro bloqueio (apos 5 tentativas).
  static const List<int> lockDurations = [1, 5, 15, 30];

  RateLimitingService(this._vaultState);

  /// Registra uma tentativa falha e retorna o estado atual.
  ///
  /// Incrementa o contador mesmo quando ja bloqueado, para que
  /// a progressao funcione corretamente (1→5→15→30min).
  Future<RateLimitResult> recordFailedAttempt() async {
    // Incrementar tentativas sempre
    final attempts = await _vaultState.incrementFailedAttempts();

    // Verificar se ja esta bloqueado
    final alreadyLocked = await _vaultState.isLocked();

    // Verificar se atingiu o limite
    if (attempts >= maxAttempts) {
      final lockIndex = _calculateLockIndex(attempts);
      final duration = lockDurations[lockIndex];
      final lockUntil = DateTime.now().add(Duration(minutes: duration));

      // So atualiza bloqueio se nao ja estiver bloqueado
      // ou se a nova duracao for maior
      if (!alreadyLocked) {
        await _vaultState.setLocked(lockUntil);
      }

      return RateLimitResult(
        isLocked: true,
        failedAttempts: attempts,
        lockDurationMinutes: duration,
        lockUntil: lockUntil,
      );
    }

    return RateLimitResult(
      isLocked: false,
      failedAttempts: attempts,
    );
  }

  /// Verifica o status atual do bloqueio.
  Future<RateLimitResult> checkLockStatus() async {
    if (await _vaultState.isLocked()) {
      return _buildLockedResult();
    }

    final attempts = await _vaultState.getFailedAttempts();
    return RateLimitResult(
      isLocked: false,
      failedAttempts: attempts,
    );
  }

  /// Reseta tentativas apos login bem-sucedido.
  Future<void> resetOnSuccess() async {
    await _vaultState.resetFailedAttempts();
    await _vaultState.clearLock();
  }

  /// Calcula o indice da duracao de bloqueio com base no numero de tentativas.
  ///
  /// Tentativa 5 → indice 0 (1min)
  /// Tentativa 6 → indice 1 (5min)
  /// Tentativa 7 → indice 2 (15min)
  /// Tentativa 8+ → indice 3 (30min)
  int _calculateLockIndex(int attempts) {
    final extra = attempts - maxAttempts;
    if (extra >= lockDurations.length) {
      return lockDurations.length - 1;
    }
    return extra;
  }

  /// Constroi um RateLimitResult para estado bloqueado.
  Future<RateLimitResult> _buildLockedResult() async {
    final lockUntil = await _vaultState.getLockUntil();
    final attempts = await _vaultState.getFailedAttempts();

    int? durationMinutes;
    if (lockUntil != null) {
      final remaining = lockUntil.difference(DateTime.now()).inMinutes;
      durationMinutes = remaining > 0 ? remaining + 1 : 0;
    }

    return RateLimitResult(
      isLocked: true,
      failedAttempts: attempts,
      lockDurationMinutes: durationMinutes,
      lockUntil: lockUntil,
    );
  }
}
