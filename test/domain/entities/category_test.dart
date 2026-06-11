import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/domain/entities/category.dart';

void main() {
  group('Category', () {
    final now = DateTime(2026, 6, 10, 12, 0, 0);

    test('deve criar com campos obrigatorios', () {
      final category = Category(
        id: 'cat-1',
        name: 'Social',
        createdAt: now,
      );

      expect(category.id, 'cat-1');
      expect(category.name, 'Social');
      expect(category.createdAt, now);
    });

    test('deve ter campos opcionais como null por padrao', () {
      final category = Category(
        id: 'cat-1',
        name: 'Social',
        createdAt: now,
      );

      expect(category.icon, isNull);
      expect(category.color, isNull);
    });

    test('deve aceitar icon e color', () {
      final category = Category(
        id: 'cat-1',
        name: 'Social',
        icon: 'people',
        color: 0xFF4CAF50,
        createdAt: now,
      );

      expect(category.icon, 'people');
      expect(category.color, 0xFF4CAF50);
    });

    test('copyWith deve criar copia com campos alterados', () {
      final original = Category(
        id: 'cat-1',
        name: 'Social',
        createdAt: now,
      );

      final copy = original.copyWith(name: 'Redes Sociais');

      expect(copy.id, 'cat-1');
      expect(copy.name, 'Redes Sociais');
      expect(copy.createdAt, now);
    });

    test('copyWith deve preservar campos nao informados', () {
      final original = Category(
        id: 'cat-1',
        name: 'Social',
        icon: 'people',
        color: 0xFF4CAF50,
        createdAt: now,
      );

      final copy = original.copyWith(name: 'Redes');

      expect(copy.icon, 'people');
      expect(copy.color, 0xFF4CAF50);
    });
  });
}
