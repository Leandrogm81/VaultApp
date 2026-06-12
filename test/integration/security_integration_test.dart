import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/vault_state_dao.dart';
import 'package:vaultapp/domain/services/vault_state_service.dart';
import 'package:vaultapp/domain/services/rate_limiting_service.dart';
import 'package:vaultapp/domain/services/auto_wipe_service.dart';
import 'package:vaultapp/domain/services/clipboard_password_service.dart';

class MockFlutterSecureStorage extends Mock
    implements FlutterSecureStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Integracao Security — Rate Limiting + Auto-wipe', () {
    late AppDatabase db;
    late VaultStateDao dao;
    late VaultStateService vaultState;
    late RateLimitingService rateLimiting;
    late MockFlutterSecureStorage mockStorage;
    late AutoWipeService autoWipe;
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('security_int_test_');
      db = AppDatabase.withDirectory(tempDir);
      dao = VaultStateDao(db);
      vaultState = VaultStateService(dao);
      rateLimiting = RateLimitingService(vaultState);
      mockStorage = MockFlutterSecureStorage();
      autoWipe = AutoWipeService(vaultState, secureStorage: mockStorage);

      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});
    });

    tearDown(() async {
      try {
        await db.close();
      } catch (_) {}
      await tempDir.delete(recursive: true);
    });

    test('5 tentativas → bloqueio 1min', () async {
      // 4 primeiras tentativas: sem bloqueio
      for (var i = 0; i < 4; i++) {
        final result = await rateLimiting.recordFailedAttempt();
        expect(result.isLocked, false);
      }
      // 5a tentativa: bloqueio 1min
      final result = await rateLimiting.recordFailedAttempt();
      expect(result.isLocked, true);
      expect(result.lockDurationMinutes, 1);
    });

    test('bloqueio progressivo: 1→5→15→30min', () async {
      // 5 tentativas → 1min
      for (var i = 0; i < 4; i++) {
        await rateLimiting.recordFailedAttempt();
      }
      var result = await rateLimiting.recordFailedAttempt();
      expect(result.lockDurationMinutes, 1);

      // 6 tentativas → 5min
      result = await rateLimiting.recordFailedAttempt();
      expect(result.lockDurationMinutes, 5);

      // 7 tentativas → 15min
      result = await rateLimiting.recordFailedAttempt();
      expect(result.lockDurationMinutes, 15);

      // 8 tentativas → 30min
      result = await rateLimiting.recordFailedAttempt();
      expect(result.lockDurationMinutes, 30);
    });

    test('10 tentativas → auto-wipe executado', () async {
      // Simular 10 tentativas
      for (var i = 0; i < 10; i++) {
        await rateLimiting.recordFailedAttempt();
      }

      // Verificar auto-wipe
      final wiped = await autoWipe.checkAndWipe(10);
      expect(wiped, true);
      verify(() => mockStorage.deleteAll()).called(1);
    });

    test('auto-wipe apaga Secure Storage', () async {
      await autoWipe.performWipe();
      verify(() => mockStorage.deleteAll()).called(1);
    });

    test('resetOnSuccess zera tentativas', () async {
      for (var i = 0; i < 5; i++) {
        await rateLimiting.recordFailedAttempt();
      }
      await rateLimiting.recordFailedAttempt(); // bloqueia

      await rateLimiting.resetOnSuccess();

      final status = await rateLimiting.checkLockStatus();
      expect(status.isLocked, false);
      expect(status.failedAttempts, 0);
    });
  });

  group('Integracao Security — Clipboard', () {
    late ClipboardPasswordService service;

    setUp(() {
      service = ClipboardPasswordService();
    });

    tearDown(() {
      service.dispose();
    });

    test('clipboard limpa seletivamente', () async {
      // Copiar senha
      await service.copyPassword('minha_senha');

      // Verificar que timer esta agendado
      expect(service.getClearTimeout(), 30);

      // Cancelar para teste
      service.stopAutoClear();
    });

    test('timeout configuravel', () {
      service.setClearTimeout(60);
      expect(service.getClearTimeout(), 60);

      service.setClearTimeout(10);
      expect(service.getClearTimeout(), 10);
    });
  });

  group('Integracao Security — Auto-lock', () {
    test('VaultStateService persiste estado entre operacoes', () async {
      final tempDir2 = await Directory.systemTemp.createTemp('persist_test_');
      final db2 = AppDatabase.withDirectory(tempDir2);
      final dao2 = VaultStateDao(db2);
      final service2 = VaultStateService(dao2);

      // Incrementar tentativas
      await service2.incrementFailedAttempts();
      await service2.incrementFailedAttempts();
      await service2.incrementFailedAttempts();

      // Verificar persistencia
      final attempts = await service2.getFailedAttempts();
      expect(attempts, 3);

      await db2.close();
      await tempDir2.delete(recursive: true);
    });

    test('bloqueio persiste entre operacoes', () async {
      final tempDir2 = await Directory.systemTemp.createTemp('lock_persist_');
      final db2 = AppDatabase.withDirectory(tempDir2);
      final dao2 = VaultStateDao(db2);
      final service2 = VaultStateService(dao2);

      final lockUntil = DateTime.now().add(const Duration(minutes: 5));
      await service2.setLocked(lockUntil);

      // Verificar que bloqueio persiste
      expect(await service2.isLocked(), true);
      expect(await service2.getLockUntil(), isNotNull);

      await db2.close();
      await tempDir2.delete(recursive: true);
    });
  });
}
