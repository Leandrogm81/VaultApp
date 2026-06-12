import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/vault_state_dao.dart';
import 'package:vaultapp/domain/services/vault_state_service.dart';

void main() {
  late AppDatabase db;
  late VaultStateDao dao;
  late VaultStateService service;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_state_svc_test_');
    db = AppDatabase.withDirectory(tempDir);
    dao = VaultStateDao(db);
    service = VaultStateService(dao);
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  group('getFailedAttempts', () {
    test('deve retornar 0 quando nao ha registro', () async {
      final attempts = await service.getFailedAttempts();
      expect(attempts, 0);
    });

    test('deve retornar valor salvo', () async {
      await dao.upsert(VaultStateTableCompanion.insert(
        failedAttempts: const Value(5),
      ));
      final attempts = await service.getFailedAttempts();
      expect(attempts, 5);
    });
  });

  group('incrementFailedAttempts', () {
    test('deve incrementar de 0 para 1', () async {
      final result = await service.incrementFailedAttempts();
      expect(result, 1);
    });

    test('deve incrementar valor existente', () async {
      await dao.upsert(VaultStateTableCompanion.insert(
        failedAttempts: const Value(3),
      ));
      final result = await service.incrementFailedAttempts();
      expect(result, 4);
    });

    test('deve persistir entre chamadas', () async {
      await service.incrementFailedAttempts();
      await service.incrementFailedAttempts();
      final result = await service.incrementFailedAttempts();
      expect(result, 3);
    });
  });

  group('resetFailedAttempts', () {
    test('deve zerar contador', () async {
      await service.incrementFailedAttempts();
      await service.incrementFailedAttempts();
      await service.resetFailedAttempts();
      final attempts = await service.getFailedAttempts();
      expect(attempts, 0);
    });
  });

  group('isLocked', () {
    test('deve retornar false quando nao ha registro', () async {
      final locked = await service.isLocked();
      expect(locked, false);
    });

    test('deve retornar false quando lock_until e null', () async {
      await dao.upsert(VaultStateTableCompanion.insert(
        locked: const Value('true'),
      ));
      final locked = await service.isLocked();
      expect(locked, false);
    });

    test('deve retornar true quando lock_until e no futuro', () async {
      final future = DateTime.now().add(const Duration(minutes: 5));
      await dao.upsert(VaultStateTableCompanion.insert(
        locked: const Value('true'),
        lockUntil: Value(future.toIso8601String()),
      ));
      final locked = await service.isLocked();
      expect(locked, true);
    });

    test('deve retornar false quando lock_until e no passado', () async {
      final past = DateTime.now().subtract(const Duration(minutes: 5));
      await dao.upsert(VaultStateTableCompanion.insert(
        locked: const Value('true'),
        lockUntil: Value(past.toIso8601String()),
      ));
      final locked = await service.isLocked();
      expect(locked, false);
    });
  });

  group('setLocked', () {
    test('deve definir bloqueio com timestamp', () async {
      final lockUntil = DateTime.now().add(const Duration(minutes: 5));
      await service.setLocked(lockUntil);

      final locked = await service.isLocked();
      expect(locked, true);

      final stored = await service.getLockUntil();
      expect(stored, isNotNull);
    });
  });

  group('clearLock', () {
    test('deve remover bloqueio', () async {
      final lockUntil = DateTime.now().add(const Duration(minutes: 5));
      await service.setLocked(lockUntil);
      await service.clearLock();

      final locked = await service.isLocked();
      expect(locked, false);

      final stored = await service.getLockUntil();
      expect(stored, isNull);
    });
  });

  group('getLockUntil', () {
    test('deve retornar null quando nao ha registro', () async {
      final result = await service.getLockUntil();
      expect(result, isNull);
    });

    test('deve retornar timestamp quando ha bloqueio', () async {
      final lockUntil = DateTime.now().add(const Duration(minutes: 5));
      await service.setLocked(lockUntil);
      final result = await service.getLockUntil();
      expect(result, isNotNull);
    });
  });
}
