import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/passwords_table.dart';

part 'password_dao.g.dart';

/// Data Access Object para a entidade Password.
///
/// CRUD completo com busca por titulo e username.
@DriftAccessor(tables: [PasswordsTable])
class PasswordDao extends DatabaseAccessor<AppDatabase>
    with _$PasswordDaoMixin {
  PasswordDao(super.db);

  /// Insere uma nova credencial e retorna o ID gerado.
  Future<int> insertPassword(PasswordsTableCompanion entry) async {
    return into(passwordsTable).insert(entry);
  }

  /// Busca uma credencial por ID. Retorna null se nao encontrar.
  Future<PasswordsTableData?> getById(String id) async {
    final query = select(passwordsTable)
      ..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// Retorna todas as credenciais.
  Future<List<PasswordsTableData>> getAll() async {
    return select(passwordsTable).get();
  }

  /// Atualiza uma credencial existente. Retorna true se afetou algum registro.
  Future<bool> updatePassword(PasswordsTableCompanion entry) async {
    return update(passwordsTable).replace(entry);
  }

  /// Remove uma credencial por ID. Retorna true se afetou algum registro.
  Future<bool> deleteById(String id) async {
    final query = delete(passwordsTable)
      ..where((t) => t.id.equals(id));
    return query.go().then((count) => count > 0);
  }

  /// Busca por titulo OU username (case-sensitive por enquanto).
  /// Usa LIKE '%query%' para busca por substring.
  Future<List<PasswordsTableData>> search(String query) async {
    final searchQuery = select(passwordsTable)
      ..where((t) => t.title.like('%$query%') | t.username.like('%$query%'));
    return searchQuery.get();
  }

  /// Limpa o categoryId de todas as senhas vinculadas a uma categoria.
  /// Usado quando a categoria e excluida — senhas ficam sem categoria.
  Future<void> clearCategoryId(String categoryId) async {
    final query = update(passwordsTable)
      ..where((t) => t.categoryId.equals(categoryId));
    await query.write(const PasswordsTableCompanion(
      categoryId: Value(null),
    ));
  }
}
