import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/vault_state_dao.dart';
import 'package:vaultapp/domain/services/vault_state_service.dart';
import 'package:vaultapp/domain/services/auto_wipe_service.dart';

class MockFlutterSecureStorage extends Mock
    implements FlutterSecureStorage {}

void main() {
  late AppDatabase db;
  late VaultStateDao dao;
  late VaultStateService vaultState;
  late MockFlutterSecureStorage mockStorage;
  late AutoWipeService service;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('auto_wipe_test_');
    db = AppDatabase.withDirectory(tempDir);
    dao = VaultStateDao(db);
    vaultState = VaultStateService(dao);
    mockStorage = MockFlutterSecureStorage();
    service = AutoWipeService(vaultState, secureStorage: mockStorage);

    when(() => mockStorage.deleteAll()).thenAnswer((_) async {});
  });

  tearDown(() async {
    try {
      await db.close();
    } catch (_) {
      // Ja fechado pelo wipe
    }
    await tempDir.delete(recursive: true);
  });

  group('getWipeThreshold', () {
    test('deve retornar 10 como default', () async {
      final threshold = await service.getWipeThreshold();
      expect(threshold, 10);
    });
  });

  group('checkAndWipe', () {
    test('deve retornar false quando tentativas < threshold', () async {
      final result = await service.checkAndWipe(5);
      expect(result, false);
    });

    test('deve retornar false quando tentativas = threshold - 1', () async {
      final result = await service.checkAndWipe(9);
      expect(result, false);
    });

    test('deve retornar true e executar wipe quando tentativas >= threshold',
        () async {
      final result = await service.checkAndWipe(10);
      expect(result, true);
      verify(() => mockStorage.deleteAll()).called(1);
    });

    test('deve retornar true quando tentativas > threshold', () async {
      final result = await service.checkAndWipe(15);
      expect(result, true);
    });
  });

  group('performWipe', () {
    test('deve limpar Secure Storage', () async {
      await service.performWipe();
      verify(() => mockStorage.deleteAll()).called(1);
    });

    test('deve resetar tentativas do vault', () async {
      // Incrementar tentativas
      await vaultState.incrementFailedAttempts();
      await vaultState.incrementFailedAttempts();
      expect(await vaultState.getFailedAttempts(), 2);

      await service.performWipe();

      expect(await vaultState.getFailedAttempts(), 0);
    });

    test('deve desbloquear vault', () async {
      final future = DateTime.now().add(const Duration(minutes: 5));
      await vaultState.setLocked(future);
      expect(await vaultState.isLocked(), true);

      await service.performWipe();

      expect(await vaultState.isLocked(), false);
    });
  });
}
