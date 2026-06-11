import 'package:drift/drift.dart';

/// Tabela de estado do vault.
///
/// Registro singleton — sempre id = "vault_state".
/// Persiste estado de bloqueio entre sessoes.
/// Nao entra no conteudo do backup.
class VaultStateTable extends Table {
  /// Identificador do registro (sempre "vault_state").
  TextColumn get id => text().withDefault(const Constant('vault_state'))();

  /// Se o vault esta bloqueado (armazenado como texto "true"/"false").
  TextColumn get locked => text().withDefault(const Constant('true'))();

  /// Numero de tentativas falhas consecutivas.
  IntColumn get failedAttempts => integer().withDefault(const Constant(0))();

  /// Data/hora ate qual o vault fica bloqueado (ISO 8601, nullable).
  TextColumn get lockUntil => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
