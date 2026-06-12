import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/vault_state_dao.dart';
import 'package:vaultapp/data/daos/user_preferences_dao.dart';
import 'package:vaultapp/domain/services/vault_state_service.dart';
import 'package:vaultapp/domain/services/preferences_service.dart';
import 'package:vaultapp/domain/services/app_lifecycle_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late VaultStateDao vaultStateDao;
  late UserPreferencesDao prefsDao;
  late VaultStateService vaultState;
  late PreferencesService prefs;
  late AppLifecycleService service;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('lifecycle_test_');
    db = AppDatabase.withDirectory(tempDir);
    vaultStateDao = VaultStateDao(db);
    prefsDao = UserPreferencesDao(db);
    vaultState = VaultStateService(vaultStateDao);
    prefs = PreferencesService(prefsDao);
    service = AppLifecycleService(vaultState, prefs);
  });

  tearDown(() async {
    service.dispose();
    await db.close();
    await tempDir.delete(recursive: true);
  });

  group('getTimeout', () {
    test('deve retornar 2 como default', () async {
      final timeout = await service.getTimeout();
      expect(timeout, 2);
    });

    test('deve retornar valor salvo', () async {
      await prefs.setAutoLockTimeout(5);
      final timeout = await service.getTimeout();
      expect(timeout, 5);
    });
  });

  group('setTimeout', () {
    test('deve salvar timeout', () async {
      await service.setTimeout(10);
      final timeout = await service.getTimeout();
      expect(timeout, 10);
    });
  });

  group('isAutoLockEnabled', () {
    test('deve retornar true quando timeout > 0', () async {
      final enabled = await service.isAutoLockEnabled();
      expect(enabled, true);
    });

    test('deve retornar false quando timeout = 0', () async {
      await prefs.setAutoLockTimeout(0);
      final enabled = await service.isAutoLockEnabled();
      expect(enabled, false);
    });
  });

  group('setEnabled', () {
    test('deve desabilitar auto-lock', () {
      service.setEnabled(false);
      // Nao deve lancar excecao
    });

    test('deve habilitar auto-lock', () {
      service.setEnabled(false);
      service.setEnabled(true);
      // Nao deve lancar excecao
    });
  });

  group('notifyBackground/Foreground', () {
    test('nao deve bloquear quando timeout nao expirou', () async {
      bool lockCalled = false;
      service.onLockRequired = () {
        lockCalled = true;
      };

      service.notifyBackground();
      // Imediatamente voltar (tempo < timeout)
      await service.notifyForeground();

      expect(lockCalled, false);
    });

    test('deve bloquear quando timeout = 0 (nunca) e background', () async {
      await prefs.setAutoLockTimeout(0);

      bool lockCalled = false;
      service.onLockRequired = () {
        lockCalled = true;
      };

      service.notifyBackground();
      await service.notifyForeground();

      // Com timeout = 0, auto-lock e desabilitado
      expect(lockCalled, false);
    });
  });
}
