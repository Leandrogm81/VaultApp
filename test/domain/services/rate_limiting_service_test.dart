import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/vault_state_dao.dart';
import 'package:vaultapp/domain/services/vault_state_service.dart';
import 'package:vaultapp/domain/services/rate_limiting_service.dart';

void main() {
  late AppDatabase db;
  late VaultStateDao dao;
  late VaultStateService vaultState;
  late RateLimitingService service;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('rate_limit_test_');
    db = AppDatabase.withDirectory(tempDir);
    dao = VaultStateDao(db);
    vaultState = VaultStateService(dao);
    service = RateLimitingService(vaultState);
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  group('recordFailedAttempt', () {
    test('deve retornar isLocked=false nas primeiras 4 tentativas', () async {
      for (var i = 1; i <= 4; i++) {
        final result = await service.recordFailedAttempt();
        expect(result.isLocked, false);
        expect(result.failedAttempts, i);
      }
    });

    test('deve retornar isLocked=true na 5a tentativa com 1min', () async {
      for (var i = 0; i < 4; i++) {
        await service.recordFailedAttempt();
      }
      final result = await service.recordFailedAttempt();
      expect(result.isLocked, true);
      expect(result.failedAttempts, 5);
      expect(result.lockDurationMinutes, 1);
      expect(result.lockUntil, isNotNull);
    });

    test('deve retornar isLocked=true na 6a tentativa com 5min', () async {
      for (var i = 0; i < 5; i++) {
        await service.recordFailedAttempt();
      }
      final result = await service.recordFailedAttempt();
      expect(result.isLocked, true);
      expect(result.failedAttempts, 6);
      expect(result.lockDurationMinutes, 5);
    });

    test('deve retornar isLocked=true na 7a tentativa com 15min', () async {
      for (var i = 0; i < 6; i++) {
        await service.recordFailedAttempt();
      }
      final result = await service.recordFailedAttempt();
      expect(result.isLocked, true);
      expect(result.failedAttempts, 7);
      expect(result.lockDurationMinutes, 15);
    });

    test('deve retornar isLocked=true na 8a tentativa com 30min', () async {
      for (var i = 0; i < 7; i++) {
        await service.recordFailedAttempt();
      }
      final result = await service.recordFailedAttempt();
      expect(result.isLocked, true);
      expect(result.failedAttempts, 8);
      expect(result.lockDurationMinutes, 30);
    });

    test('deve retornar 30min para tentativas acima de 8', () async {
      for (var i = 0; i < 10; i++) {
        await service.recordFailedAttempt();
      }
      final result = await service.recordFailedAttempt();
      expect(result.isLocked, true);
      expect(result.lockDurationMinutes, 30);
    });

    test('deve incrementar mesmo quando ja bloqueado', () async {
      for (var i = 0; i < 5; i++) {
        await service.recordFailedAttempt();
      }
      // Primeira chamada bloqueia
      final first = await service.recordFailedAttempt();
      expect(first.isLocked, true);

      // Segunda chamada incrementa contador
      final second = await service.recordFailedAttempt();
      expect(second.isLocked, true);
      expect(second.failedAttempts, first.failedAttempts + 1);
    });
  });

  group('checkLockStatus', () {
    test('deve retornar isLocked=false quando nao ha tentativas', () async {
      final result = await service.checkLockStatus();
      expect(result.isLocked, false);
      expect(result.failedAttempts, 0);
    });

    test('deve retornar isLocked=true quando bloqueado', () async {
      for (var i = 0; i < 5; i++) {
        await service.recordFailedAttempt();
      }
      final result = await service.checkLockStatus();
      expect(result.isLocked, true);
    });

    test('deve retornar tentativas corretas', () async {
      await service.recordFailedAttempt();
      await service.recordFailedAttempt();
      final result = await service.checkLockStatus();
      expect(result.failedAttempts, 2);
    });
  });

  group('resetOnSuccess', () {
    test('deve zerar tentativas e desbloquear', () async {
      for (var i = 0; i < 5; i++) {
        await service.recordFailedAttempt();
      }
      // Bloqueia
      final locked = await service.recordFailedAttempt();
      expect(locked.isLocked, true);

      // Reseta
      await service.resetOnSuccess();

      // Verifica
      final result = await service.checkLockStatus();
      expect(result.isLocked, false);
      expect(result.failedAttempts, 0);
    });

    test('deve funcionar mesmo sem tentativas', () async {
      await service.resetOnSuccess();
      final result = await service.checkLockStatus();
      expect(result.isLocked, false);
      expect(result.failedAttempts, 0);
    });
  });
}
