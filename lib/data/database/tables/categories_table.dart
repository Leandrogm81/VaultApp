import 'package:drift/drift.dart';

/// Tabela de categorias de organizacao.
///
/// Categorias pre-definidas: Social, Email, Banco, Compras, Trabalho, Outros.
/// O usuario pode criar, editar e excluir categorias.
class CategoriesTable extends Table {
  /// Chave primaria (UUID).
  TextColumn get id => text()();

  /// Nome da categoria.
  TextColumn get name => text()();

  /// Identificador do icone (nullable).
  TextColumn get icon => text().nullable()();

  /// Cor em formato ARGB int (nullable).
  IntColumn get color => integer().nullable()();

  /// Data/hora de criacao (ISO 8601).
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
