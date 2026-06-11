import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/vault_state_table.dart';

part 'vault_state_dao.g.dart';

/// Data Access Object para VaultState.
///
/// Registro singleton — get retorna o registro ou null, upsert insere ou atualiza.
@DriftAccessor(tables: [VaultStateTable])
class VaultStateDao extends DatabaseAccessor<AppDatabase>
    with _$VaultStateDaoMixin {
  VaultStateDao(super.db);

  /// Retorna o estado do vault ou null se nao existe.
  Future<VaultStateTableData?> get() async {
    final query = select(vaultStateTable)
      ..where((t) => t.id.equals('vault_state'));
    return query.getSingleOrNull();
  }

  /// Insere ou atualiza o estado do vault (upsert baseado no id).
  Future<void> upsert(VaultStateTableCompanion entry) async {
    await into(vaultStateTable).insertOnConflictUpdate(entry);
  }
}
