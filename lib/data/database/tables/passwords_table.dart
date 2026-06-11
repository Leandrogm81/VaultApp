import 'package:drift/drift.dart';

/// Tabela de credenciais do vault.
///
/// Colunas `password` e `notes` serao criptografadas antes de gravar (Sprint 4).
/// Tags sao armazenadas como JSON string (nao tabela separada).
/// Datas sao armazenadas como ISO 8601 (TEXT).
class PasswordsTable extends Table {
  /// Chave primaria (UUID).
  TextColumn get id => text()();

  /// FK para categoria (nullable).
  TextColumn get categoryId => text().nullable()();

  /// Titulo da credencial.
  TextColumn get title => text()();

  /// Nome de usuario (texto claro, permite busca).
  TextColumn get username => text()();

  /// Senha (criptografada com AES-256-GCM na camada de servico).
  TextColumn get password => text()();

  /// URL do servico (nullable).
  TextColumn get url => text().nullable()();

  /// Observacoes (criptografadas, nullable).
  TextColumn get notes => text().nullable()();

  /// Tags como JSON array serializado (ex: '["dev","work"]').
  TextColumn get tags => text().withDefault(const Constant('[]'))();

  /// Se esta nos favoritos.
  Column<bool> get favorite => boolean().withDefault(const Constant(false))();

  /// Data/hora de criacao (ISO 8601).
  TextColumn get createdAt => text()();

  /// Data/hora da ultima atualizacao (ISO 8601).
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
