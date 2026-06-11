import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../data/daos/category_dao.dart';
import '../../data/daos/password_dao.dart';
import '../entities/category.dart';

/// Modelo que combina categoria com contagem de senhas vinculadas.
class CategoryWithCount {
  /// A categoria.
  final Category category;

  /// Quantidade de senhas vinculadas.
  final int count;

  const CategoryWithCount({required this.category, required this.count});
}

/// Servico de categorias com operacoes CRUD.
///
/// Gerencia criar, listar, editar, excluir categorias.
/// Garantir que excluir categoria nao remove senhas associadas.
class CategoryService {
  final CategoryDao _categoryDao;
  final PasswordDao _passwordDao;
  CategoryService(this._categoryDao, this._passwordDao);

  /// Cria uma nova categoria e retorna a entidade Category.
  Future<Category> createCategory({
    required String name,
    String? icon,
    int? color,
  }) async {
    final id = _generateId();
    final now = DateTime.now().toIso8601String();

    await _categoryDao.insertCategory(
      CategoriesTableCompanion.insert(
        id: id,
        name: name,
        icon: Value(icon),
        color: Value(color),
        createdAt: now,
      ),
    );

    return Category(
      id: id,
      name: name,
      icon: icon,
      color: color,
      createdAt: DateTime.now(),
    );
  }

  /// Retorna todas as categorias.
  Future<List<Category>> getCategories() async {
    final rows = await _categoryDao.getAll();
    return rows.map(_rowToCategory).toList();
  }

  /// Retorna uma categoria pelo ID.
  Future<Category?> getCategoryById(String id) async {
    final row = await _categoryDao.getById(id);
    if (row == null) return null;
    return _rowToCategory(row);
  }

  /// Atualiza uma categoria existente.
  Future<Category> updateCategory({
    required String id,
    required String name,
    String? icon,
    int? color,
  }) async {
    // Busca categoria existente para obter createdAt
    final existing = await _categoryDao.getById(id);
    final createdAt = existing?.createdAt ?? DateTime.now().toIso8601String();

    await _categoryDao.updateCategory(
      CategoriesTableCompanion(
        id: Value(id),
        name: Value(name),
        icon: Value(icon),
        color: Value(color),
        createdAt: Value(createdAt),
      ),
    );

    return Category(
      id: id,
      name: name,
      icon: icon,
      color: color,
      createdAt: DateTime.now(),
    );
  }

  /// Exclui uma categoria pelo ID.
  /// Limpa categoryId das senhas vinculadas e depois exclui a categoria.
  Future<void> deleteCategory(String id) async {
    await _passwordDao.clearCategoryId(id);
    await _categoryDao.deleteById(id);
  }

  /// Retorna a contagem de senhas vinculadas a uma categoria.
  Future<int> getCategoryPasswordCount(String categoryId) async {
    return _categoryDao.countPasswords(categoryId);
  }

  /// Retorna todas as categorias com contagem de senhas.
  Future<List<CategoryWithCount>> getAllCategoriesWithCount() async {
    final categories = await getCategories();
    final result = <CategoryWithCount>[];

    for (final category in categories) {
      final count = await getCategoryPasswordCount(category.id);
      result.add(CategoryWithCount(category: category, count: count));
    }

    return result;
  }

  /// Converte uma linha do banco para a entidade Category.
  Category _rowToCategory(CategoriesTableData row) {
    return Category(
      id: row.id,
      name: row.name,
      icon: row.icon,
      color: row.color,
      createdAt: DateTime.tryParse(row.createdAt) ?? DateTime.now(),
    );
  }

  /// Gera um ID unico (UUID v4 simplificado).
  String _generateId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = (now * 10000 + now % 10000);
    return '$random-${now.toRadixString(16)}';
  }
}
