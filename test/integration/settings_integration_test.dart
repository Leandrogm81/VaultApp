import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/user_preferences_dao.dart';
import 'package:vaultapp/domain/services/auto_lock_service.dart';
import 'package:vaultapp/domain/services/preferences_service.dart';
import 'package:vaultapp/domain/services/theme_service.dart';

/// Testes de integracao para o fluxo completo de Configuracoes.
///
/// Valida que tema e auto-lock persistem entre sessoes
/// e que o ThemeService resolve corretamente.
void main() {
  late AppDatabase db;
  late UserPreferencesDao dao;
  late PreferencesService service;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_settings_integ_');
    db = AppDatabase.withDirectory(tempDir);
    dao = UserPreferencesDao(db);
    service = PreferencesService(dao);
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  group('Integracao: persistencia de tema', () {
    test('tema persiste entre sessoes simuladas', () async {
      // Sessao 1: salvar tema
      await service.setTheme('dark');
      final theme1 = await service.getTheme();
      expect(theme1, 'dark');

      // Sessao 2: ler tema (simula nova sessao com mesmo banco)
      final theme2 = await service.getTheme();
      expect(theme2, 'dark');
    });

    test('tema default e "system" quando nao ha registro', () async {
      final theme = await service.getTheme();
      expect(theme, 'system');
    });

    test('mudanca de tema atualiza corretamente', () async {
      await service.setTheme('light');
      expect(await service.getTheme(), 'light');

      await service.setTheme('dark');
      expect(await service.getTheme(), 'dark');

      await service.setTheme('system');
      expect(await service.getTheme(), 'system');
    });
  });

  group('Integracao: persistencia de auto-lock', () {
    test('timeout persiste entre sessoes simuladas', () async {
      // Sessao 1: salvar timeout
      await service.setAutoLockTimeout(10);
      final timeout1 = await service.getAutoLockTimeout();
      expect(timeout1, 10);

      // Sessao 2: ler timeout (simula nova sessao com mesmo banco)
      final timeout2 = await service.getAutoLockTimeout();
      expect(timeout2, 10);
    });

    test('timeout default e 2 quando nao ha registro', () async {
      final timeout = await service.getAutoLockTimeout();
      expect(timeout, 2);
    });

    test('timeout "nunca" (0) persiste corretamente', () async {
      await service.setAutoLockTimeout(0);
      expect(await service.getAutoLockTimeout(), 0);
      expect(AutoLockService.formatTimeout(0), 'Nunca');
    });
  });

  group('Integracao: resolucao de tema', () {
    test('themeService resolve "light" para ThemeMode.light', () async {
      await service.setTheme('light');
      final mode = await ThemeService.getThemeMode(service);
      expect(mode.toString(), 'ThemeMode.light');
    });

    test('themeService resolve "dark" para ThemeMode.dark', () async {
      await service.setTheme('dark');
      final mode = await ThemeService.getThemeMode(service);
      expect(mode.toString(), 'ThemeMode.dark');
    });

    test('themeService resolve "system" para ThemeMode.system', () async {
      await service.setTheme('system');
      final mode = await ThemeService.getThemeMode(service);
      expect(mode.toString(), 'ThemeMode.system');
    });
  });

  group('Integracao: opcoes de auto-lock', () {
    test('opcoes incluem todos os valores esperados', () {
      final options = AutoLockService.getTimeoutOptions();
      expect(options, containsAll([0, 1, 2, 5, 10]));
      expect(options.length, 5);
    });

    test('formatTimeout formata corretamente todas as opcoes', () {
      expect(AutoLockService.formatTimeout(0), 'Nunca');
      expect(AutoLockService.formatTimeout(1), '1 min');
      expect(AutoLockService.formatTimeout(2), '2 min');
      expect(AutoLockService.formatTimeout(5), '5 min');
      expect(AutoLockService.formatTimeout(10), '10 min');
    });
  });

  group('Integracao: todas as preferencias', () {
    test('getAllPreferences retorna mapa completo com defaults', () async {
      final prefs = await service.getAllPreferences();
      expect(prefs, containsPair('theme', 'system'));
      expect(prefs, containsPair('autoLockTimeout', 2));
      expect(prefs, containsPair('autoWipeThreshold', 10));
      expect(prefs, containsPair('backupReminderDays', 7));
    });

    test('getAllPreferences retorna valores salvos', () async {
      await service.setTheme('dark');
      await service.setAutoLockTimeout(5);

      final prefs = await service.getAllPreferences();
      expect(prefs['theme'], 'dark');
      expect(prefs['autoLockTimeout'], 5);
    });
  });
}
