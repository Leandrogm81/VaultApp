import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/password_dao.dart';
import 'package:vaultapp/domain/services/tag_service.dart';

/// Testes de integracao do fluxo completo de busca e tags.
void main() {
  late AppDatabase database;
  late PasswordDao passwordDao;
  late TagService tagService;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_sprint7_test_');
    database = AppDatabase.withDirectory(tempDir);
    passwordDao = PasswordDao(database);
    tagService = TagService(passwordDao);
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  PasswordsTableCompanion makePassword({
    required String id,
    required String title,
    required String username,
    String password = 'senha123',
    String tags = '[]',
    bool favorite = false,
  }) {
    final now = DateTime.now().toIso8601String();
    return PasswordsTableCompanion.insert(
      id: id,
      title: title,
      username: username,
      password: password,
      tags: Value(tags),
      favorite: Value(favorite),
      createdAt: now,
      updatedAt: now,
    );
  }

  group('Search Integration', () {
    test('busca retorna resultados corretos', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'GitHub', username: 'user@email.com'),
      );
      await passwordDao.insertPassword(
        makePassword(id: 'pw-2', title: 'GitLab', username: 'admin@email.com'),
      );
      await passwordDao.insertPassword(
        makePassword(id: 'pw-3', title: 'Gmail', username: 'user@gmail.com'),
      );

      final results = await passwordDao.searchPasswords('Git');
      expect(results.length, 2);
      expect(results.any((r) => r.title == 'GitHub'), true);
      expect(results.any((r) => r.title == 'GitLab'), true);
    });

    test('busca case-insensitive funciona', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'GitHub', username: 'User@Email.COM'),
      );

      final r1 = await passwordDao.searchPasswords('github');
      final r2 = await passwordDao.searchPasswords('GITHUB');
      final r3 = await passwordDao.searchPasswords('GiThUb');

      expect(r1.length, 1);
      expect(r2.length, 1);
      expect(r3.length, 1);
    });

    test('busca por substring funciona', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'GitHub', username: 'dev'),
      );
      await passwordDao.insertPassword(
        makePassword(id: 'pw-2', title: 'GitLab', username: 'dev'),
      );
      await passwordDao.insertPassword(
        makePassword(id: 'pw-3', title: 'Bitbucket', username: 'dev'),
      );

      final results = await passwordDao.searchPasswords('hub');
      expect(results.length, 1);
      expect(results.first.title, 'GitHub');
    });

    test('busca vazia retorna todas as senhas', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'GitHub', username: 'user'),
      );
      await passwordDao.insertPassword(
        makePassword(id: 'pw-2', title: 'GitLab', username: 'user'),
      );

      final results = await passwordDao.searchPasswords('');
      expect(results.length, 2);
    });

    test('busca sem correspondencia retorna lista vazia', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'GitHub', username: 'user'),
      );

      final results = await passwordDao.searchPasswords('xyz');
      expect(results, isEmpty);
    });

    test('busca combina titulo e username', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'Mail', username: 'admin@github.com'),
      );
      await passwordDao.insertPassword(
        makePassword(id: 'pw-2', title: 'GitHub', username: 'user'),
      );

      final results = await passwordDao.searchPasswords('github');
      expect(results.length, 2);
    });
  });

  group('Tags Integration', () {
    test('tags sao salvas como JSON array', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'GitHub', username: 'user',
            tags: '["work","dev"]'),
      );

      final password = await passwordDao.getById('pw-1');
      expect(password, isNotNull);

      final tags = tagService.deserializeTags(password!.tags);
      expect(tags, ['work', 'dev']);
    });

    test('maximo 10 tags respeitado', () async {
      final tags = List.generate(10, (i) => 'tag$i');
      expect(tagService.validateTagList(tags), true);

      final tooMany = List.generate(11, (i) => 'tag$i');
      expect(tagService.validateTagList(tooMany), false);
    });

    test('tags sao desserializadas corretamente na edicao', () async {
      final tagsJson = tagService.serializeTags(['personal', 'bank', 'email']);
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'Nubank', username: 'user',
            tags: tagsJson),
      );

      final password = await passwordDao.getById('pw-1');
      final loadedTags = tagService.deserializeTags(password!.tags);
      expect(loadedTags, ['personal', 'bank', 'email']);
    });

    test('adicionar tag a senha existente', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'GitHub', username: 'user',
            tags: '["work"]'),
      );

      await tagService.addTagToPassword('pw-1', 'dev');

      final password = await passwordDao.getById('pw-1');
      final tags = tagService.deserializeTags(password!.tags);
      expect(tags, ['work', 'dev']);
    });

    test('remover tag de senha existente', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'GitHub', username: 'user',
            tags: '["work","dev"]'),
      );

      await tagService.removeTagFromPassword('pw-1', 'work');

      final password = await passwordDao.getById('pw-1');
      final tags = tagService.deserializeTags(password!.tags);
      expect(tags, ['dev']);
    });

    test('tags existentes sao coletadas de todas as senhas', () async {
      await passwordDao.insertPassword(
        makePassword(id: 'pw-1', title: 'GitHub', username: 'user',
            tags: '["work","dev"]'),
      );
      await passwordDao.insertPassword(
        makePassword(id: 'pw-2', title: 'Gmail', username: 'user',
            tags: '["work","personal"]'),
      );

      final existingTags = await tagService.getExistingTags();
      expect(existingTags, ['dev', 'personal', 'work']);
    });
  });
}
