import 'package:drift/drift.dart';

/// Tabela de metadados de backup.
///
/// Registro singleton — sempre id = "main".
/// Usada para consultar estado antes de sobrepor arquivo na nuvem.
/// Nao entra no conteudo do backup.
class BackupMetaTable extends Table {
  /// Identificador do registro (sempre "main").
  TextColumn get id => text().withDefault(const Constant('main'))();

  /// Data/hora do ultimo backup (ISO 8601, nullable).
  TextColumn get lastBackup => text().nullable()();

  /// Hash do ultimo arquivo de backup (nullable).
  TextColumn get fileHash => text().nullable()();

  /// Caminho do arquivo na nuvem (nullable).
  TextColumn get cloudPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
