// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_state_dao.dart';

// ignore_for_file: type=lint
mixin _$VaultStateDaoMixin on DatabaseAccessor<AppDatabase> {
  $VaultStateTableTable get vaultStateTable => attachedDatabase.vaultStateTable;
  VaultStateDaoManager get managers => VaultStateDaoManager(this);
}

class VaultStateDaoManager {
  final _$VaultStateDaoMixin _db;
  VaultStateDaoManager(this._db);
  $$VaultStateTableTableTableManager get vaultStateTable =>
      $$VaultStateTableTableTableManager(
        _db.attachedDatabase,
        _db.vaultStateTable,
      );
}
