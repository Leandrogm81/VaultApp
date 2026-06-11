import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/passwords_table.dart';
import 'tables/categories_table.dart';
import 'tables/backup_meta_table.dart';
import 'tables/vault_state_table.dart';
import 'tables/user_preferences_table.dart';

part 'app_database.g.dart';

/// Classe principal do banco de dados Drift.
///
/// Referencia todas as 5 tabelas do vault.
/// Usa Drift com SQLite nativo (via drift/sqlite3_flutter_libs).
@DriftDatabase(tables: [
  PasswordsTable,
  CategoriesTable,
  BackupMetaTable,
  VaultStateTable,
  UserPreferencesTable,
])
class AppDatabase extends _$AppDatabase {
  /// Abre o banco de dados com o caminho padrao.
  AppDatabase() : super(_openConnection());

  /// Abre o banco de dados em um diretorio customizado (para testes).
  AppDatabase.withDirectory(Directory dir)
      : super(NativeDatabase.createInBackground(
          File(p.join(dir.path, 'vault.db')),
        ));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'vault.db'));
    return NativeDatabase.createInBackground(file);
  });
}
