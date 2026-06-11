import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import 'package:vaultapp/data/database/app_database.dart';
import 'package:vaultapp/data/daos/category_dao.dart';
import 'package:vaultapp/data/daos/password_dao.dart';
import 'package:vaultapp/domain/services/category_service.dart';

/// Testes de integração do fluxo completo:
/// criar categoria, vincular senha, filtrar favoritos, excluir categoria.
void main() {
  late AppDatabase database;
  late CategoryDao categoryDao;
  late PasswordDao passwordDao;
  late CategoryService categoryService;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vault_sprint6_test_');
    database = AppDatabase.withDirectory(tempDir);
    categoryDao = CategoryDao(database);
    passwordDao = PasswordDao(database);
    categoryService = CategoryService(categoryDao, passwordDao);
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  // Fluxo 1: criar categoria → listar → verificar contagem
  test('Fluxo 1: criar categoria, listar e verificar contagem', () async {
    // Criar categoria
    final category = await categoryService.createCategory(
      name: 'Social',
      icon: 'social',
      color: 0xFF1D4ED8,
    );

    expect(category.name, 'Social');
    expect(category.id.isNotEmpty, true);

    // Listar categorias
    final categories = await categoryService.getCategories();
    expect(categories.length, 1);
    expect(categories.first.name, 'Social');

    // Verificar contagem (deve ser 0 pois nao ha senhas)
    final count = await categoryService.getCategoryPasswordCount(category.id);
    expect(count, 0);
  });

  // Fluxo 2: editar categoria → verificar atualização
  test('Fluxo 2: editar categoria e verificar atualizacao', () async {
    // Criar categoria
    final category = await categoryService.createCategory(
      name: 'Social',
      icon: 'social',
      color: 0xFF1D4ED8,
    );

    // Editar categoria
    final updated = await categoryService.updateCategory(
      id: category.id,
      name: 'Redes Sociais',
      icon: 'email',
      color: 0xFF15803D,
    );

    expect(updated.name, 'Redes Sociais');
    expect(updated.icon, 'email');
    expect(updated.color, 0xFF15803D);

    // Verificar que foi atualizada
    final fetched = await categoryService.getCategoryById(category.id);
    expect(fetched, isNotNull);
    expect(fetched!.name, 'Redes Sociais');
  });

  // Fluxo 3: excluir categoria → verificar que senhas permanecem
  test('Fluxo 3: excluir categoria nao remove senhas', () async {
    // Criar categoria
    final category = await categoryService.createCategory(
      name: 'Banco',
      icon: 'bank',
      color: 0xFFB45309,
    );

    // Criar senha vinculada a categoria
    final now = DateTime.now().toIso8601String();
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-test-001',
        title: 'Nubank',
        username: 'user@email.com',
        password: 'senha123',
        categoryId: Value(category.id),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Verificar que senha existe
    final passwords = await passwordDao.getAll();
    expect(passwords.length, 1);

    // Excluir categoria
    await categoryService.deleteCategory(category.id);

    // Verificar que categoria foi removida
    final categories = await categoryService.getCategories();
    expect(categories.length, 0);

    // Verificar que senha permanece (sem categoria)
    final passwordsAfter = await passwordDao.getAll();
    expect(passwordsAfter.length, 1);
    expect(passwordsAfter.first.categoryId, isNull);
  });

  // Fluxo 4: vincular senha a categoria → verificar contagem
  test('Fluxo 4: vincular senha a categoria atualiza contagem', () async {
    // Criar categoria
    final category = await categoryService.createCategory(
      name: 'Trabalho',
      icon: 'work',
      color: 0xFF7C3AED,
    );

    // Verificar contagem inicial
    final countBefore =
        await categoryService.getCategoryPasswordCount(category.id);
    expect(countBefore, 0);

    // Criar senha vinculada
    final now = DateTime.now().toIso8601String();
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-test-002',
        title: 'Slack',
        username: 'user@company.com',
        password: 'senha456',
        categoryId: Value(category.id),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Verificar contagem apos vinculacao
    final countAfter =
        await categoryService.getCategoryPasswordCount(category.id);
    expect(countAfter, 1);

    // Criar segunda senha vinculada
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-test-003',
        title: 'Jira',
        username: 'user@company.com',
        password: 'senha789',
        categoryId: Value(category.id),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Verificar contagem final
    final countFinal =
        await categoryService.getCategoryPasswordCount(category.id);
    expect(countFinal, 2);
  });

  // Fluxo 5: marcar favorito → filtrar favoritos
  test('Fluxo 5: marcar favorito e filtrar', () async {
    final now = DateTime.now().toIso8601String();

    // Criar 3 senhas (2 favoritas)
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-fav-001',
        title: 'GitHub',
        username: 'user@email.com',
        password: 'senha1',
        favorite: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-fav-002',
        title: 'Gmail',
        username: 'user@gmail.com',
        password: 'senha2',
        favorite: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-fav-003',
        title: 'Slack',
        username: 'user@company.com',
        password: 'senha3',
        favorite: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Listar todas
    final all = await passwordDao.getAll();
    expect(all.length, 3);

    // Filtrar favoritas (simulando logica do HomeNotifier)
    final favorites = all.where((p) => p.favorite).toList();
    expect(favorites.length, 2);
    expect(favorites[0].title, 'GitHub');
    expect(favorites[1].title, 'Slack');
  });

  // Fluxo 6: desmarcar favorito → verificar remoção do filtro
  test('Fluxo 6: desmarcar favorito remove do filtro', () async {
    final now = DateTime.now().toIso8601String();

    // Criar senha favorita
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-unfav-001',
        title: 'GitHub',
        username: 'user@email.com',
        password: 'senha1',
        favorite: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Verificar que e favorita
    var password = await passwordDao.getById('pw-unfav-001');
    expect(password!.favorite, true);

    // Desmarcar favorito
    await passwordDao.updatePassword(
      PasswordsTableCompanion.insert(
        id: 'pw-unfav-001',
        title: 'GitHub',
        username: 'user@email.com',
        password: 'senha1',
        favorite: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Verificar que nao e mais favorita
    password = await passwordDao.getById('pw-unfav-001');
    expect(password!.favorite, false);

    // Listar todas e filtrar favoritas
    final all = await passwordDao.getAll();
    final favorites = all.where((p) => p.favorite).toList();
    expect(favorites.length, 0);
  });

  // Teste auxiliar: getAllCategoriesWithCount retorna categorias com contagem
  test('getAllCategoriesWithCount retorna categorias com contagem correta',
      () async {
    // Criar categorias
    final cat1 = await categoryService.createCategory(name: 'Social');
    final cat2 = await categoryService.createCategory(name: 'Banco');

    // Criar senhas vinculadas
    final now = DateTime.now().toIso8601String();
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-count-001',
        title: 'Facebook',
        username: 'user@email.com',
        password: 'senha1',
        categoryId: Value(cat1.id),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-count-002',
        title: 'Instagram',
        username: 'user@email.com',
        password: 'senha2',
        categoryId: Value(cat1.id),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await passwordDao.insertPassword(
      PasswordsTableCompanion.insert(
        id: 'pw-count-003',
        title: 'Nubank',
        username: 'user@email.com',
        password: 'senha3',
        categoryId: Value(cat2.id),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Verificar contagem
    final result = await categoryService.getAllCategoriesWithCount();
    expect(result.length, 2);

    final socialCount =
        result.firstWhere((r) => r.category.name == 'Social').count;
    expect(socialCount, 2);

    final bancoCount =
        result.firstWhere((r) => r.category.name == 'Banco').count;
    expect(bancoCount, 1);
  });
}
