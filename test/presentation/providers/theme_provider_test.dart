import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaultapp/domain/services/preferences_service.dart';
import 'package:vaultapp/presentation/providers/theme_provider.dart';
import 'package:vaultapp/presentation/viewmodels/settings_viewmodel.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefs;

  setUp(() {
    mockPrefs = MockPreferencesService();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        preferencesServiceProvider.overrideWithValue(mockPrefs),
      ],
    );
  }

  group('ThemeNotifier', () {
    test('estado inicial deve ter preference="system" e themeMode=system', () {
      final container = createContainer();
      final state = container.read(themeProvider);
      expect(state.preference, 'system');
      expect(state.themeMode, ThemeMode.system);
    });

    test('loadTheme deve carregar preferencia do banco', () async {
      when(() => mockPrefs.getTheme()).thenAnswer((_) async => 'dark');

      final container = createContainer();
      await container.read(themeProvider.notifier).loadTheme();

      final state = container.read(themeProvider);
      expect(state.preference, 'dark');
      expect(state.themeMode, ThemeMode.dark);
    });

    test('setTheme deve salvar e atualizar estado', () async {
      when(() => mockPrefs.setTheme(any())).thenAnswer((_) async {});
      when(() => mockPrefs.getTheme()).thenAnswer((_) async => 'light');

      final container = createContainer();
      await container.read(themeProvider.notifier).setTheme('light');

      final state = container.read(themeProvider);
      expect(state.preference, 'light');
      expect(state.themeMode, ThemeMode.light);
      verify(() => mockPrefs.setTheme('light')).called(1);
    });

    test('setTheme para "system" deve resolver ThemeMode.system', () async {
      when(() => mockPrefs.setTheme(any())).thenAnswer((_) async {});
      when(() => mockPrefs.getTheme()).thenAnswer((_) async => 'system');

      final container = createContainer();
      await container.read(themeProvider.notifier).setTheme('system');

      final state = container.read(themeProvider);
      expect(state.preference, 'system');
      expect(state.themeMode, ThemeMode.system);
    });
  });
}
