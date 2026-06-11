import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/backup_meta_dao.dart';
import 'package:vaultapp/data/daos/vault_state_dao.dart';
import 'package:vaultapp/data/daos/user_preferences_dao.dart';

void main() {
  late AppDatabase db;
  late BackupMetaDao backupMetaDao;
  late VaultStateDao vaultStateDao;
  late UserPreferencesDao userPrefsDao;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_aux_test_');
    db = AppDatabase.withDirectory(tempDir);
    backupMetaDao = BackupMetaDao(db);
    vaultStateDao = VaultStateDao(db);
    userPrefsDao = UserPreferencesDao(db);
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  group('BackupMetaDao', () {
    test('get deve retornar null quando nao ha registro', () async {
      final result = await backupMetaDao.get();
      expect(result, isNull);
    });

    test('upsert deve inserir novo registro', () async {
      final now = DateTime.now().toIso8601String();
      await backupMetaDao.upsert(BackupMetaTableCompanion.insert(
        lastBackup: Value(now),
        fileHash: Value('hash123'),
        cloudPath: Value('/backups/vault.enc'),
      ));
      final result = await backupMetaDao.get();
      expect(result, isNotNull);
      expect(result!.fileHash, 'hash123');
    });

    test('upsert deve atualizar registro existente', () async {
      await backupMetaDao.upsert(BackupMetaTableCompanion.insert(
        fileHash: Value('hash1'),
      ));
      await backupMetaDao.upsert(BackupMetaTableCompanion.insert(
        fileHash: Value('hash2'),
      ));
      final result = await backupMetaDao.get();
      expect(result!.fileHash, 'hash2');
    });
  });

  group('VaultStateDao', () {
    test('get deve retornar null quando nao ha registro', () async {
      final result = await vaultStateDao.get();
      expect(result, isNull);
    });

    test('upsert deve inserir novo registro', () async {
      await vaultStateDao.upsert(VaultStateTableCompanion.insert(
        failedAttempts: const Value(3),
      ));
      final result = await vaultStateDao.get();
      expect(result, isNotNull);
      expect(result!.failedAttempts, 3);
    });

    test('upsert deve atualizar registro existente', () async {
      await vaultStateDao.upsert(VaultStateTableCompanion.insert(
        failedAttempts: const Value(1),
      ));
      await vaultStateDao.upsert(VaultStateTableCompanion.insert(
        failedAttempts: const Value(5),
      ));
      final result = await vaultStateDao.get();
      expect(result!.failedAttempts, 5);
    });
  });

  group('UserPreferencesDao', () {
    test('get deve retornar null quando nao ha registro', () async {
      final result = await userPrefsDao.get();
      expect(result, isNull);
    });

    test('upsert deve inserir novo registro com valores padrao', () async {
      await userPrefsDao.upsert(UserPreferencesTableCompanion.insert(
        theme: const Value('dark'),
        autoLockTimeout: const Value(5),
      ));
      final result = await userPrefsDao.get();
      expect(result, isNotNull);
      expect(result!.theme, 'dark');
      expect(result.autoLockTimeout, 5);
    });

    test('upsert deve atualizar registro existente', () async {
      await userPrefsDao.upsert(UserPreferencesTableCompanion.insert(
        theme: const Value('light'),
      ));
      await userPrefsDao.upsert(UserPreferencesTableCompanion.insert(
        theme: const Value('dark'),
      ));
      final result = await userPrefsDao.get();
      expect(result!.theme, 'dark');
    });
  });
}
