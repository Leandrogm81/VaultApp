/// Entidade que armazena as preferencias do usuario.
///
/// Entra no conteudo do backup.
class UserPreferences {
  /// Tema do app (ex: "light", "dark", "system").
  final String theme;

  /// Timeout de auto-lock em minutos (default: 2).
  final int autoLockTimeout;

  /// Numero de tentativas antes do auto-wipe (default: 10).
  final int autoWipeThreshold;

  /// Dias entre lembretes de backup (default: 7).
  final int backupReminderDays;

  const UserPreferences({
    this.theme = 'system',
    this.autoLockTimeout = 2,
    this.autoWipeThreshold = 10,
    this.backupReminderDays = 7,
  });

  /// Preferencias padrao do sistema.
  factory UserPreferences.defaults() => const UserPreferences();

  /// Cria uma copia com campos alterados.
  UserPreferences copyWith({
    String? theme,
    int? autoLockTimeout,
    int? autoWipeThreshold,
    int? backupReminderDays,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      autoWipeThreshold: autoWipeThreshold ?? this.autoWipeThreshold,
      backupReminderDays: backupReminderDays ?? this.backupReminderDays,
    );
  }
}
