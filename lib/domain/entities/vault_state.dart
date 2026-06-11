/// Entidade que persiste o estado de bloqueio do vault entre sessoes.
///
/// Nao entra no conteudo do backup.
class VaultState {
  /// Se o vault esta bloqueado (true = bloqueado).
  final bool locked;

  /// Numero de tentativas falhas consecutivas.
  final int failedAttempts;

  /// Data/hora ate qual o vault fica bloqueado (nullable — sem bloqueio temporal).
  final DateTime? lockUntil;

  const VaultState({
    this.locked = true,
    this.failedAttempts = 0,
    this.lockUntil,
  });

  /// Estado inicial padrao (bloqueado, sem tentativas).
  factory VaultState.initial() => const VaultState(locked: true);

  /// Cria uma copia com campos alterados.
  VaultState copyWith({
    bool? locked,
    int? failedAttempts,
    DateTime? lockUntil,
  }) {
    return VaultState(
      locked: locked ?? this.locked,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockUntil: lockUntil ?? this.lockUntil,
    );
  }
}
