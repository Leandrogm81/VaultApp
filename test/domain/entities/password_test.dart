import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/domain/entities/password.dart';

void main() {
  group('Password', () {
    final now = DateTime(2026, 6, 10, 12, 0, 0);

    test('deve criar com todos os campos obrigatorios', () {
      final password = Password(
        id: 'test-id',
        title: 'GitHub',
        username: 'user@email.com',
        password: 'minha_senha',
        createdAt: now,
        updatedAt: now,
      );

      expect(password.id, 'test-id');
      expect(password.title, 'GitHub');
      expect(password.username, 'user@email.com');
      expect(password.password, 'minha_senha');
      expect(password.createdAt, now);
      expect(password.updatedAt, now);
    });

    test('deve ter campos nullable como null por padrao', () {
      final password = Password(
        id: 'test-id',
        title: 'GitHub',
        username: 'user',
        password: 'pass',
        createdAt: now,
        updatedAt: now,
      );

      expect(password.categoryId, isNull);
      expect(password.url, isNull);
      expect(password.notes, isNull);
    });

    test('deve aceitar tags como List<String>', () {
      final password = Password(
        id: 'test-id',
        title: 'GitHub',
        username: 'user',
        password: 'pass',
        tags: ['dev', 'work', 'important'],
        createdAt: now,
        updatedAt: now,
      );

      expect(password.tags, ['dev', 'work', 'important']);
      expect(password.tags.length, 3);
    });

    test('deve ter tags vazia por padrao', () {
      final password = Password(
        id: 'test-id',
        title: 'GitHub',
        username: 'user',
        password: 'pass',
        createdAt: now,
        updatedAt: now,
      );

      expect(password.tags, isEmpty);
    });

    test('deve ter favorite como false por padrao', () {
      final password = Password(
        id: 'test-id',
        title: 'GitHub',
        username: 'user',
        password: 'pass',
        createdAt: now,
        updatedAt: now,
      );

      expect(password.favorite, false);
    });

    test('deve aceitar favorite como true', () {
      final password = Password(
        id: 'test-id',
        title: 'GitHub',
        username: 'user',
        password: 'pass',
        favorite: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(password.favorite, true);
    });

    test('copyWith deve criar copia com campos alterados', () {
      final original = Password(
        id: 'test-id',
        title: 'GitHub',
        username: 'user',
        password: 'pass',
        createdAt: now,
        updatedAt: now,
      );

      final copy = original.copyWith(
        title: 'GitLab',
        favorite: true,
      );

      expect(copy.id, 'test-id');
      expect(copy.title, 'GitLab');
      expect(copy.favorite, true);
      expect(copy.username, 'user'); // nao alterado
    });

    test('copyWith deve preservar campos nao informados', () {
      final original = Password(
        id: 'test-id',
        title: 'GitHub',
        username: 'user',
        password: 'pass',
        url: 'https://github.com',
        notes: 'minhas notas',
        tags: ['dev'],
        createdAt: now,
        updatedAt: now,
      );

      final copy = original.copyWith(title: 'GitLab');

      expect(copy.url, 'https://github.com');
      expect(copy.notes, 'minhas notas');
      expect(copy.tags, ['dev']);
    });
  });
}
