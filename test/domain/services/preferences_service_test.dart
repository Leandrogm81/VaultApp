import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/user_preferences_dao.dart';
import 'package:vaultapp/domain/services/preferences_service.dart';

void main() {
  late AppDatabase db;
  late UserPreferencesDao dao;
  late PreferencesService service;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_prefs_test_');
    db = AppDatabase.withDirectory(tempDir);
    dao = UserPreferencesDao(db);
    service = PreferencesService(dao);
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  group('getTheme', () {
    test('deve retornar "system" como default quando nao ha registro', () async {
      final theme = await service.getTheme();
      expect(theme, 'system');
    });

    test('deve retornar tema salvo', () async {
      await dao.upsert(UserPreferencesTableCompanion.insert(
        theme: const Value('dark'),
      ));
      final theme = await service.getTheme();
      expect(theme, 'dark');
    });
  });

  group('setTheme', () {
    test('deve salvar tema', () async {
      await service.setTheme('dark');
      final theme = await service.getTheme();
      expect(theme, 'dark');
    });

    test('deve atualizar tema existente', () async {
      await service.setTheme('light');
      await service.setTheme('dark');
      final theme = await service.getTheme();
      expect(theme, 'dark');
    });

    test('deve preservar autoLockTimeout ao alterar tema', () async {
      await dao.upsert(UserPreferencesTableCompanion.insert(
        theme: const Value('light'),
        autoLockTimeout: const Value(5),
      ));
      await service.setTheme('dark');
      final timeout = await service.getAutoLockTimeout();
      expect(timeout, 5);
    });
  });

  group('getAutoLockTimeout', () {
    test('deve retornar 2 como default quando nao ha registro', () async {
      final timeout = await service.getAutoLockTimeout();
      expect(timeout, 2);
    });

    test('deve retornar timeout salvo', () async {
      await dao.upsert(UserPreferencesTableCompanion.insert(
        autoLockTimeout: const Value(10),
      ));
      final timeout = await service.getAutoLockTimeout();
      expect(timeout, 10);
    });
  });

  group('setAutoLockTimeout', () {
    test('deve salvar timeout', () async {
      await service.setAutoLockTimeout(5);
      final timeout = await service.getAutoLockTimeout();
      expect(timeout, 5);
    });

    test('deve atualizar timeout existente', () async {
      await service.setAutoLockTimeout(1);
      await service.setAutoLockTimeout(10);
      final timeout = await service.getAutoLockTimeout();
      expect(timeout, 10);
    });

    test('deve preservar tema ao alterar timeout', () async {
      await dao.upsert(UserPreferencesTableCompanion.insert(
        theme: const Value('dark'),
        autoLockTimeout: const Value(2),
      ));
      await service.setAutoLockTimeout(10);
      final theme = await service.getTheme();
      expect(theme, 'dark');
    });
  });

  group('getAllPreferences', () {
    test('deve retornar mapa com defaults quando nao ha registro', () async {
      final prefs = await service.getAllPreferences();
      expect(prefs['theme'], 'system');
      expect(prefs['autoLockTimeout'], 2);
      expect(prefs['autoWipeThreshold'], 10);
      expect(prefs['backupReminderDays'], 7);
    });

    test('deve retornar mapa com valores salvos', () async {
      await dao.upsert(UserPreferencesTableCompanion.insert(
        theme: const Value('dark'),
        autoLockTimeout: const Value(5),
      ));
      final prefs = await service.getAllPreferences();
      expect(prefs['theme'], 'dark');
      expect(prefs['autoLockTimeout'], 5);
    });
  });
}
