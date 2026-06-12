import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/preferences_service.dart';

/// Estado da tela de Configuracoes.
class SettingsState {
  /// Tema atual ("system", "light", "dark").
  final String theme;

  /// Timeout de auto-lock em minutos.
  final int autoLockTimeout;

  /// Se esta carregando preferencias.
  final bool isLoading;

  /// Mensagem de erro (null quando nao ha erro).
  final String? errorMessage;

  const SettingsState({
    this.theme = 'system',
    this.autoLockTimeout = 2,
    this.isLoading = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    String? theme,
    int? autoLockTimeout,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// ViewModel para a tela de Configuracoes (Notifier do Riverpod 3.x).
///
/// Gerencia estado de tema e auto-lock timeout.
class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    return const SettingsState();
  }

  /// Busca todas as preferencias do banco.
  Future<void> loadPreferences() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final prefsService = ref.read(preferencesServiceProvider);
      final theme = await prefsService.getTheme();
      final timeout = await prefsService.getAutoLockTimeout();
      state = state.copyWith(
        theme: theme,
        autoLockTimeout: timeout,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar configuracoes',
      );
    }
  }

  /// Salva e atualiza o tema.
  Future<void> setTheme(String theme) async {
    try {
      final prefsService = ref.read(preferencesServiceProvider);
      await prefsService.setTheme(theme);
      state = state.copyWith(theme: theme, clearError: true);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Erro ao salvar tema');
    }
  }

  /// Salva e atualiza o timeout de auto-lock.
  Future<void> setAutoLockTimeout(int minutes) async {
    try {
      final prefsService = ref.read(preferencesServiceProvider);
      await prefsService.setAutoLockTimeout(minutes);
      state = state.copyWith(autoLockTimeout: minutes, clearError: true);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao salvar timeout de auto-lock',
      );
    }
  }
}

/// Provider do PreferencesService.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError(
    'preferencesServiceProvider deve ser sobrescrito no ProviderScope',
  );
});

/// Provider do SettingsNotifier.
final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
