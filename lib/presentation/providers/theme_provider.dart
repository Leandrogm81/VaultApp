import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/theme_service.dart';
import '../viewmodels/settings_viewmodel.dart';

/// Estado do tema do app.
class ThemeState {
  /// Preferencia do usuario ("light", "dark", "system").
  final String preference;

  /// ThemeMode resolvido.
  final ThemeMode themeMode;

  const ThemeState({
    this.preference = 'system',
    this.themeMode = ThemeMode.system,
  });

  ThemeState copyWith({String? preference, ThemeMode? themeMode}) {
    return ThemeState(
      preference: preference ?? this.preference,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

/// Notifier para gerenciar o tema do app.
///
/// Conecta PreferencesService ao ThemeMode, permitindo mudanca reativa.
class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return const ThemeState();
  }

  /// Carrega a preferencia de tema do banco e resolve para ThemeMode.
  Future<void> loadTheme() async {
    final prefsService = ref.read(preferencesServiceProvider);
    final themeMode = await ThemeService.getThemeMode(prefsService);
    final preference = await prefsService.getTheme();
    state = ThemeState(preference: preference, themeMode: themeMode);
  }

  /// Altera o tema e persiste a preferencia.
  Future<void> setTheme(String preference) async {
    final prefsService = ref.read(preferencesServiceProvider);
    await prefsService.setTheme(preference);
    final themeMode = ThemeService.resolveTheme(preference);
    state = ThemeState(preference: preference, themeMode: themeMode);
  }
}

/// Provider do ThemeNotifier.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);
