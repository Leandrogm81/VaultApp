import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/password_dao.dart';

void main() {
  late AppDatabase db;
  late PasswordDao dao;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_dao_test_');
    db = AppDatabase.withDirectory(tempDir);
    dao = PasswordDao(db);
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  PasswordsTableCompanion makePassword({
    String id = 'test-id',
    String title = 'GitHub',
    String username = 'user@email.com',
    String password = 'minha_senha',
    String? categoryId,
    String? url,
    String? notes,
    String tags = '[]',
    bool favorite = false,
    String? createdAt,
    String? now,
  }) {
    return PasswordsTableCompanion.insert(
      id: id,
      title: title,
      username: username,
      password: password,
      createdAt: createdAt ?? DateTime.now().toIso8601String(),
      updatedAt: now ?? DateTime.now().toIso8601String(),
      categoryId: Value(categoryId),
      url: Value(url),
      notes: Value(notes),
      tags: Value(tags),
      favorite: Value(favorite),
    );
  }

  group('PasswordDao', () {
    test('insert deve inserir o registro', () async {
      final entry = makePassword(id: 'pw-1');
      await dao.insertPassword(entry);
      final result = await dao.getById('pw-1');
      expect(result, isNotNull);
      expect(result!.id, 'pw-1');
    });

    test('getById deve retornar null para ID inexistente', () async {
      final result = await dao.getById('nonexistent');
      expect(result, isNull);
    });

    test('getById deve retornar a senha correta', () async {
      await dao.insertPassword(makePassword(id: 'pw-1', title: 'GitHub'));
      final result = await dao.getById('pw-1');
      expect(result, isNotNull);
      expect(result!.title, 'GitHub');
      expect(result.username, 'user@email.com');
    });

    test('getAll deve retornar lista vazia quando nao ha registros', () async {
      final result = await dao.getAll();
      expect(result, isEmpty);
    });

    test('getAll deve retornar todos os registros', () async {
      await dao.insertPassword(makePassword(id: 'pw-1', title: 'GitHub'));
      await dao.insertPassword(makePassword(id: 'pw-2', title: 'GitLab'));
      final result = await dao.getAll();
      expect(result.length, 2);
    });

    test('updatePassword deve alterar o registro', () async {
      await dao.insertPassword(makePassword(id: 'pw-1', title: 'GitHub'));
      final entry = makePassword(id: 'pw-1', title: 'GitLab');
      final updated = await dao.updatePassword(entry);
      expect(updated, true);

      final result = await dao.getById('pw-1');
      expect(result!.title, 'GitLab');
    });

    test('deleteById deve remover o registro', () async {
      await dao.insertPassword(makePassword(id: 'pw-1'));
      final deleted = await dao.deleteById('pw-1');
      expect(deleted, true);

      final result = await dao.getById('pw-1');
      expect(result, isNull);
    });

    test('search deve encontrar por titulo', () async {
      await dao.insertPassword(makePassword(id: 'pw-1', title: 'GitHub'));
      await dao.insertPassword(makePassword(id: 'pw-2', title: 'GitLab'));
      final results = await dao.search('Git');
      expect(results.length, 2);
    });

    test('search deve encontrar por username', () async {
      await dao.insertPassword(
          makePassword(id: 'pw-1', title: 'Mail', username: 'user@gmail.com'));
      await dao.insertPassword(
          makePassword(id: 'pw-2', title: 'Other', username: 'admin@github.com'));
      final results = await dao.search('admin');
      expect(results.length, 1);
      expect(results.first.username, 'admin@github.com');
    });

    test('search deve retornar vazio quando nao ha correspondencia', () async {
      await dao.insertPassword(makePassword(id: 'pw-1', title: 'GitHub'));
      final results = await dao.search('xyz');
      expect(results, isEmpty);
    });

    test('search deve encontrar por titulo OU username', () async {
      await dao.insertPassword(
          makePassword(id: 'pw-1', title: 'GitHub', username: 'user'));
      await dao.insertPassword(
          makePassword(id: 'pw-2', title: 'Other', username: 'github_user'));
      final results = await dao.search('github');
      expect(results.length, 2);
    });
  });
}
