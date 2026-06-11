import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/category_dao.dart';
import 'package:vaultapp/data/daos/password_dao.dart';

void main() {
  late AppDatabase db;
  late CategoryDao categoryDao;
  late PasswordDao passwordDao;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_category_test_');
    db = AppDatabase.withDirectory(tempDir);
    categoryDao = CategoryDao(db);
    passwordDao = PasswordDao(db);
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  CategoriesTableCompanion makeCategory({
    String id = 'cat-1',
    String name = 'Social',
    String? icon,
    int? color,
    String? createdAt,
  }) {
    return CategoriesTableCompanion.insert(
      id: id,
      name: name,
      createdAt: createdAt ?? DateTime.now().toIso8601String(),
      icon: Value(icon),
      color: Value(color),
    );
  }

  PasswordsTableCompanion makePassword({
    String id = 'pw-1',
    String title = 'GitHub',
    String username = 'user',
    String password = 'pass',
    String? categoryId,
  }) {
    return PasswordsTableCompanion.insert(
      id: id,
      title: title,
      username: username,
      password: password,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      categoryId: Value(categoryId),
    );
  }

  group('CategoryDao', () {
    test('insert deve inserir a categoria', () async {
      final entry = makeCategory(id: 'cat-1');
      await categoryDao.insertCategory(entry);
      final result = await categoryDao.getById('cat-1');
      expect(result, isNotNull);
      expect(result!.name, 'Social');
    });

    test('getById deve retornar null para ID inexistente', () async {
      final result = await categoryDao.getById('nonexistent');
      expect(result, isNull);
    });

    test('getAll deve retornar lista vazia quando nao ha registros', () async {
      final result = await categoryDao.getAll();
      expect(result, isEmpty);
    });

    test('getAll deve retornar todas as categorias', () async {
      await categoryDao.insertCategory(makeCategory(id: 'cat-1', name: 'Social'));
      await categoryDao.insertCategory(makeCategory(id: 'cat-2', name: 'Banco'));
      final result = await categoryDao.getAll();
      expect(result.length, 2);
    });

    test('updateCategory deve alterar o registro', () async {
      await categoryDao.insertCategory(makeCategory(id: 'cat-1', name: 'Social'));
      final entry = makeCategory(id: 'cat-1', name: 'Redes Sociais');
      final updated = await categoryDao.updateCategory(entry);
      expect(updated, true);

      final result = await categoryDao.getById('cat-1');
      expect(result!.name, 'Redes Sociais');
    });

    test('deleteById deve remover o registro', () async {
      await categoryDao.insertCategory(makeCategory(id: 'cat-1'));
      final deleted = await categoryDao.deleteById('cat-1');
      expect(deleted, true);

      final result = await categoryDao.getById('cat-1');
      expect(result, isNull);
    });

    test('countPasswords deve retornar 0 para categoria sem senhas', () async {
      await categoryDao.insertCategory(makeCategory(id: 'cat-1'));
      final count = await categoryDao.countPasswords('cat-1');
      expect(count, 0);
    });

    test('countPasswords deve retornar contagem correta', () async {
      await categoryDao.insertCategory(makeCategory(id: 'cat-1'));
      await passwordDao.insertPassword(makePassword(id: 'pw-1', categoryId: 'cat-1'));
      await passwordDao.insertPassword(makePassword(id: 'pw-2', categoryId: 'cat-1'));
      await passwordDao.insertPassword(makePassword(id: 'pw-3', categoryId: 'cat-2'));

      final count = await categoryDao.countPasswords('cat-1');
      expect(count, 2);
    });
  });
}
