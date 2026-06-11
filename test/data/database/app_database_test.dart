import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_test_');
    db = AppDatabase.withDirectory(tempDir);
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  group('AppDatabase', () {
    test('deve abrir o banco sem erro', () async {
      // Verifica que o banco foi criado e pode executar queries
      final result = await db.select(db.passwordsTable).get();
      expect(result, isEmpty);
    });

    test('deve criar todas as 5 tabelas', () async {
      // Verifica que cada tabela existe e pode ser consultada
      final passwords = await db.select(db.passwordsTable).get();
      final categories = await db.select(db.categoriesTable).get();
      final backupMeta = await db.select(db.backupMetaTable).get();
      final vaultState = await db.select(db.vaultStateTable).get();
      final userPrefs = await db.select(db.userPreferencesTable).get();

      expect(passwords, isEmpty);
      expect(categories, isEmpty);
      expect(backupMeta, isEmpty);
      expect(vaultState, isEmpty);
      expect(userPrefs, isEmpty);
    });

    test('schemaVersion deve retornar 1', () {
      expect(db.schemaVersion, 1);
    });
  });
}
