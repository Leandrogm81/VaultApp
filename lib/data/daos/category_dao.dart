import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/categories_table.dart';
import '../database/tables/passwords_table.dart';

part 'category_dao.g.dart';

/// Data Access Object para a entidade Category.
///
/// CRUD completo com contagem de senhas por categoria.
@DriftAccessor(tables: [CategoriesTable, PasswordsTable])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  /// Insere uma nova categoria e retorna o rowid.
  Future<int> insertCategory(CategoriesTableCompanion entry) async {
    return into(categoriesTable).insert(entry);
  }

  /// Busca uma categoria por ID. Retorna null se nao encontrar.
  Future<CategoriesTableData?> getById(String id) async {
    final query = select(categoriesTable)
      ..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// Retorna todas as categorias.
  Future<List<CategoriesTableData>> getAll() async {
    return select(categoriesTable).get();
  }

  /// Atualiza uma categoria existente. Retorna true se afetou algum registro.
  Future<bool> updateCategory(CategoriesTableCompanion entry) async {
    return update(categoriesTable).replace(entry);
  }

  /// Remove uma categoria por ID. Retorna true se afetou algum registro.
  Future<bool> deleteById(String id) async {
    final query = delete(categoriesTable)
      ..where((t) => t.id.equals(id));
    return query.go().then((count) => count > 0);
  }

  /// Conta quantas senhas estao vinculadas a uma categoria.
  Future<int> countPasswords(String categoryId) async {
    final query = selectOnly(passwordsTable)
      ..addColumns([passwordsTable.id.count()])
      ..where(passwordsTable.categoryId.equals(categoryId));
    final result = await query.getSingle();
    return result.read(passwordsTable.id.count()) ?? 0;
  }
}
