// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_dao.dart';

// ignore_for_file: type=lint
mixin _$PasswordDaoMixin on DatabaseAccessor<AppDatabase> {
  $PasswordsTableTable get passwordsTable => attachedDatabase.passwordsTable;
  PasswordDaoManager get managers => PasswordDaoManager(this);
}

class PasswordDaoManager {
  final _$PasswordDaoMixin _db;
  PasswordDaoManager(this._db);
  $$PasswordsTableTableTableManager get passwordsTable =>
      $$PasswordsTableTableTableManager(
        _db.attachedDatabase,
        _db.passwordsTable,
      );
}
