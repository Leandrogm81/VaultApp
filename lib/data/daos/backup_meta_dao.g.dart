// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_meta_dao.dart';

// ignore_for_file: type=lint
mixin _$BackupMetaDaoMixin on DatabaseAccessor<AppDatabase> {
  $BackupMetaTableTable get backupMetaTable => attachedDatabase.backupMetaTable;
  BackupMetaDaoManager get managers => BackupMetaDaoManager(this);
}

class BackupMetaDaoManager {
  final _$BackupMetaDaoMixin _db;
  BackupMetaDaoManager(this._db);
  $$BackupMetaTableTableTableManager get backupMetaTable =>
      $$BackupMetaTableTableTableManager(
        _db.attachedDatabase,
        _db.backupMetaTable,
      );
}
