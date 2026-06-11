import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/password_dao.dart';
import 'package:vaultapp/domain/services/tag_service.dart';

void main() {
  late AppDatabase db;
  late PasswordDao dao;
  late TagService tagService;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_tag_test_');
    db = AppDatabase.withDirectory(tempDir);
    dao = PasswordDao(db);
    tagService = TagService(dao);
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
    String tags = '[]',
  }) {
    final now = DateTime.now().toIso8601String();
    return PasswordsTableCompanion.insert(
      id: id,
      title: title,
      username: username,
      password: password,
      tags: Value(tags),
      createdAt: now,
      updatedAt: now,
    );
  }

  group('TagService', () {
    group('serializeTags', () {
      test('deve serializar lista vazia para JSON array vazio', () {
        final result = tagService.serializeTags([]);
        expect(result, '[]');
      });

      test('deve serializar lista com uma tag', () {
        final result = tagService.serializeTags(['work']);
        expect(result, '["work"]');
      });

      test('deve serializar lista com multiplas tags', () {
        final result = tagService.serializeTags(['dev', 'work', 'personal']);
        expect(result, '["dev","work","personal"]');
      });
    });

    group('deserializeTags', () {
      test('deve deserializar JSON array vazio', () {
        final result = tagService.deserializeTags('[]');
        expect(result, isEmpty);
      });

      test('deve deserializar string vazia', () {
        final result = tagService.deserializeTags('');
        expect(result, isEmpty);
      });

      test('deve deserializar array com uma tag', () {
        final result = tagService.deserializeTags('["work"]');
        expect(result, ['work']);
      });

      test('deve deserializar array com multiplas tags', () {
        final result = tagService.deserializeTags('["dev","work","personal"]');
        expect(result, ['dev', 'work', 'personal']);
      });

      test('deve retornar lista vazia para JSON invalido', () {
        final result = tagService.deserializeTags('invalid json');
        expect(result, isEmpty);
      });
    });

    group('validateTagList', () {
      test('deve aceitar lista vazia', () {
        expect(tagService.validateTagList([]), true);
      });

      test('deve aceitar ate 10 tags', () {
        final tags = List.generate(10, (i) => 'tag$i');
        expect(tagService.validateTagList(tags), true);
      });

      test('deve rejeitar mais de 10 tags', () {
        final tags = List.generate(11, (i) => 'tag$i');
        expect(tagService.validateTagList(tags), false);
      });

      test('deve aceitar 1 tag', () {
        expect(tagService.validateTagList(['work']), true);
      });
    });

    group('getExistingTags', () {
      test('deve retornar lista vazia quando nao ha senhas', () async {
        final tags = await tagService.getExistingTags();
        expect(tags, isEmpty);
      });

      test('deve retornar tags unicas de todas as senhas', () async {
        await dao.insertPassword(makePassword(
          id: 'pw-1',
          tags: '["work","dev"]',
        ));
        await dao.insertPassword(makePassword(
          id: 'pw-2',
          tags: '["work","personal"]',
        ));

        final tags = await tagService.getExistingTags();
        expect(tags, ['dev', 'personal', 'work']);
      });

      test('deve retornar tags ordenadas', () async {
        await dao.insertPassword(makePassword(
          id: 'pw-1',
          tags: '["zebra","alpha"]',
        ));

        final tags = await tagService.getExistingTags();
        expect(tags, ['alpha', 'zebra']);
      });

      test('deve ignorar senhas sem tags', () async {
        await dao.insertPassword(makePassword(
          id: 'pw-1',
          tags: '[]',
        ));
        await dao.insertPassword(makePassword(
          id: 'pw-2',
          tags: '["work"]',
        ));

        final tags = await tagService.getExistingTags();
        expect(tags, ['work']);
      });
    });

    group('addTagToPassword', () {
      test('deve adicionar tag a senha', () async {
        await dao.insertPassword(makePassword(id: 'pw-1', tags: '[]'));

        await tagService.addTagToPassword('pw-1', 'work');

        final updated = await dao.getById('pw-1');
        final tags = tagService.deserializeTags(updated!.tags);
        expect(tags, ['work']);
      });

      test('deve adicionar multiplas tags', () async {
        await dao.insertPassword(makePassword(id: 'pw-1', tags: '[]'));

        await tagService.addTagToPassword('pw-1', 'work');
        await tagService.addTagToPassword('pw-1', 'dev');

        final updated = await dao.getById('pw-1');
        final tags = tagService.deserializeTags(updated!.tags);
        expect(tags, ['work', 'dev']);
      });

      test('nao deve duplicar tag existente', () async {
        await dao.insertPassword(makePassword(id: 'pw-1', tags: '["work"]'));

        await tagService.addTagToPassword('pw-1', 'work');

        final updated = await dao.getById('pw-1');
        final tags = tagService.deserializeTags(updated!.tags);
        expect(tags.length, 1);
      });

      test('nao deve adicionar tag quando limite atingido', () async {
        final tags = List.generate(10, (i) => 'tag$i');
        final json = tagService.serializeTags(tags);
        await dao.insertPassword(makePassword(id: 'pw-1', tags: json));

        await tagService.addTagToPassword('pw-1', 'extra');

        final updated = await dao.getById('pw-1');
        final updatedTags = tagService.deserializeTags(updated!.tags);
        expect(updatedTags.length, 10);
      });

      test('deve lancar excecao para senha inexistente', () async {
        expect(
          () => tagService.addTagToPassword('nonexistent', 'work'),
          throwsException,
        );
      });
    });

    group('removeTagFromPassword', () {
      test('deve remover tag de senha', () async {
        await dao.insertPassword(makePassword(
          id: 'pw-1',
          tags: '["work","dev"]',
        ));

        await tagService.removeTagFromPassword('pw-1', 'work');

        final updated = await dao.getById('pw-1');
        final tags = tagService.deserializeTags(updated!.tags);
        expect(tags, ['dev']);
      });

      test('deve deixar array vazio ao remover ultima tag', () async {
        await dao.insertPassword(makePassword(
          id: 'pw-1',
          tags: '["work"]',
        ));

        await tagService.removeTagFromPassword('pw-1', 'work');

        final updated = await dao.getById('pw-1');
        final tags = tagService.deserializeTags(updated!.tags);
        expect(tags, isEmpty);
      });

      test('nao deve falhar ao remover tag inexistente', () async {
        await dao.insertPassword(makePassword(
          id: 'pw-1',
          tags: '["work"]',
        ));

        await tagService.removeTagFromPassword('pw-1', 'nonexistent');

        final updated = await dao.getById('pw-1');
        final tags = tagService.deserializeTags(updated!.tags);
        expect(tags, ['work']);
      });

      test('deve lancar excecao para senha inexistente', () async {
        expect(
          () => tagService.removeTagFromPassword('nonexistent', 'work'),
          throwsException,
        );
      });
    });
  });
}
