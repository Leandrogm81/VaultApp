import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/user_preferences_table.dart';

part 'user_preferences_dao.g.dart';

/// Data Access Object para UserPreferences.
///
/// Registro singleton — get retorna o registro ou null, upsert insere ou atualiza.
@DriftAccessor(tables: [UserPreferencesTable])
class UserPreferencesDao extends DatabaseAccessor<AppDatabase>
    with _$UserPreferencesDaoMixin {
  UserPreferencesDao(super.db);

  /// Retorna as preferencias do usuario ou null se nao existe.
  Future<UserPreferencesTableData?> get() async {
    final query = select(userPreferencesTable)
      ..where((t) => t.id.equals('user_preferences'));
    return query.getSingleOrNull();
  }

  /// Insere ou atualiza as preferencias do usuario (upsert baseado no id).
  Future<void> upsert(UserPreferencesTableCompanion entry) async {
    await into(userPreferencesTable).insertOnConflictUpdate(entry);
  }
}
