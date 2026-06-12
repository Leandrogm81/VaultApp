import 'package:drift/drift.dart';

import '../../data/daos/user_preferences_dao.dart';
import '../../data/database/app_database.dart';

/// Servico de persistencia para preferencias do usuario.
///
/// Wrapper sobre o UserPreferencesDao (Drift) para expor
/// leitura e escrita de tema, auto-lock timeout e outras configuracoes.
/// Usa a tabela UserPreferencesTable existente (schema version 1).
class PreferencesService {
  final UserPreferencesDao _dao;

  PreferencesService(UserPreferencesDao dao) : _dao = dao;

  /// Tema default: "system".
  static const String defaultTheme = 'system';

  /// Auto-lock timeout default: 2 minutos.
  static const int defaultAutoLockTimeout = 2;

  /// Retorna o tema salvo ou o default ("system").
  Future<String> getTheme() async {
    final prefs = await _dao.get();
    return prefs?.theme ?? defaultTheme;
  }

  /// Salva o tema.
  Future<void> setTheme(String theme) async {
    final existing = await _dao.get();
    await _dao.upsert(
      UserPreferencesTableCompanion(
        id: const Value('user_preferences'),
        theme: Value(theme),
        autoLockTimeout: Value(
          existing?.autoLockTimeout ?? defaultAutoLockTimeout,
        ),
      ),
    );
  }

  /// Retorna o timeout de auto-lock em minutos ou o default (2).
  Future<int> getAutoLockTimeout() async {
    final prefs = await _dao.get();
    return prefs?.autoLockTimeout ?? defaultAutoLockTimeout;
  }

  /// Salva o timeout de auto-lock em minutos.
  Future<void> setAutoLockTimeout(int minutes) async {
    final existing = await _dao.get();
    await _dao.upsert(
      UserPreferencesTableCompanion(
        id: const Value('user_preferences'),
        theme: Value(existing?.theme ?? defaultTheme),
        autoLockTimeout: Value(minutes),
      ),
    );
  }

  /// Retorna todas as preferencias como mapa.
  Future<Map<String, dynamic>> getAllPreferences() async {
    final prefs = await _dao.get();
    return {
      'theme': prefs?.theme ?? defaultTheme,
      'autoLockTimeout': prefs?.autoLockTimeout ?? defaultAutoLockTimeout,
      'autoWipeThreshold': prefs?.autoWipeThreshold ?? 10,
      'backupReminderDays': prefs?.backupReminderDays ?? 7,
    };
  }
}
