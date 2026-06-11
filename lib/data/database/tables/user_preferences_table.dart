import 'package:drift/drift.dart';

/// Tabela de preferencias do usuario.
///
/// Registro singleton — sempre id = "user_preferences".
/// Entra no conteudo do backup.
class UserPreferencesTable extends Table {
  /// Identificador do registro (sempre "user_preferences").
  TextColumn get id => text().withDefault(const Constant('user_preferences'))();

  /// Tema do app (ex: "light", "dark", "system").
  TextColumn get theme => text().withDefault(const Constant('system'))();

  /// Timeout de auto-lock em minutos (default: 2).
  IntColumn get autoLockTimeout => integer().withDefault(const Constant(2))();

  /// Numero de tentativas antes do auto-wipe (default: 10).
  IntColumn get autoWipeThreshold => integer().withDefault(const Constant(10))();

  /// Dias entre lembretes de backup (default: 7).
  IntColumn get backupReminderDays => integer().withDefault(const Constant(7))();

  @override
  Set<Column> get primaryKey => {id};
}
