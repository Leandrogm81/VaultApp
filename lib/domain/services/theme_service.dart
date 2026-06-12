import 'package:flutter/material.dart';

import '../../domain/services/preferences_service.dart';

/// Servico de tema do VaultApp.
///
/// Resolve a preferencia do usuario (claro/escuro/sistema) para um ThemeMode.
/// "Sistema" segue a preferencia do OS.
class ThemeService {
  /// Resolve a string de preferencia para ThemeMode.
  ///
  /// Valores validos: "light", "dark", "system".
  /// Default: ThemeMode.system.
  static ThemeMode resolveTheme(String themePreference) {
    switch (themePreference) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  /// Busca a preferencia do usuario e resolve para ThemeMode.
  static Future<ThemeMode> getThemeMode(PreferencesService prefs) async {
    final preference = await prefs.getTheme();
    return resolveTheme(preference);
  }
}
