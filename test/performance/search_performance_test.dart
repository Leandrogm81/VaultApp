import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/password_dao.dart';

/// Testes de performance para busca com muitos registros.
void main() {
  late AppDatabase database;
  late PasswordDao passwordDao;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_perf_test_');
    database = AppDatabase.withDirectory(tempDir);
    passwordDao = PasswordDao(database);
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  /// Insere N senhas no banco para testes de performance.
  Future<void> insertPasswords(int count) async {
    final now = DateTime.now().toIso8601String();
    for (var i = 0; i < count; i++) {
      await passwordDao.insertPassword(
        PasswordsTableCompanion.insert(
          id: 'pw-perf-$i',
          title: 'Service $i',
          username: 'user$i@email.com',
          password: 'senha$i',
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  group('Search Performance', () {
    test('busca com 500+ senhas deve ser menor que 500ms', () async {
      await insertPasswords(500);

      final stopwatch = Stopwatch()..start();
      final results = await passwordDao.searchPasswords('Service 250');
      stopwatch.stop();

      expect(results.length, 1);
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(500),
        reason:
            'Busca com 500 senhas levou ${stopwatch.elapsedMilliseconds}ms '
            '(limite: 500ms)',
      );
    });

    test('busca com 1000 senhas deve ser menor que 500ms', () async {
      await insertPasswords(1000);

      final stopwatch = Stopwatch()..start();
      final results = await passwordDao.searchPasswords('user500');
      stopwatch.stop();

      expect(results.length, 1);
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(500),
        reason:
            'Busca com 1000 senhas levou ${stopwatch.elapsedMilliseconds}ms '
            '(limite: 500ms)',
      );
    });

    test('busca case-insensitive com muitos registros', () async {
      await insertPasswords(500);

      final stopwatch = Stopwatch()..start();
      final results = await passwordDao.searchPasswords('SERVICE');
      stopwatch.stop();

      expect(results.length, 500);
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(500),
        reason:
            'Busca case-insensitive com 500 senhas levou '
            '${stopwatch.elapsedMilliseconds}ms (limite: 500ms)',
      );
    });

    test('busca por substring com muitos registros', () async {
      await insertPasswords(500);

      final stopwatch = Stopwatch()..start();
      final results = await passwordDao.searchPasswords('emai');
      stopwatch.stop();

      // Todas as 500 senhas tem "email" no username
      expect(results.length, 500);
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(500),
        reason:
            'Busca por substring com 500 senhas levou '
            '${stopwatch.elapsedMilliseconds}ms (limite: 500ms)',
      );
    });

    test('getAll com 500+ senhas deve ser rapido', () async {
      await insertPasswords(500);

      final stopwatch = Stopwatch()..start();
      final results = await passwordDao.getAll();
      stopwatch.stop();

      expect(results.length, 500);
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(200),
        reason:
            'getAll com 500 senhas levou ${stopwatch.elapsedMilliseconds}ms',
      );
    });
  });
}
