import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/backup_meta_table.dart';

part 'backup_meta_dao.g.dart';

/// Data Access Object para BackupMeta.
///
/// Registro singleton — get retorna o registro ou null, upsert insere ou atualiza.
@DriftAccessor(tables: [BackupMetaTable])
class BackupMetaDao extends DatabaseAccessor<AppDatabase>
    with _$BackupMetaDaoMixin {
  BackupMetaDao(super.db);

  /// Retorna o registro de metadados ou null se nao existe.
  Future<BackupMetaTableData?> get() async {
    final query = select(backupMetaTable)
      ..where((t) => t.id.equals('main'));
    return query.getSingleOrNull();
  }

  /// Insere ou atualiza o registro de metadados (upsert baseado no id).
  Future<void> upsert(BackupMetaTableCompanion entry) async {
    await into(backupMetaTable).insertOnConflictUpdate(entry);
  }
}
