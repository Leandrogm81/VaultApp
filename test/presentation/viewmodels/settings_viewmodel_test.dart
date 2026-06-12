import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaultapp/domain/services/preferences_service.dart';
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

  group('SettingsNotifier', () {
    test('estado inicial deve ter theme="system" e autoLockTimeout=2', () {
      final container = createContainer();
      final state = container.read(settingsProvider);
      expect(state.theme, 'system');
      expect(state.autoLockTimeout, 2);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
    });

    test('loadPreferences deve carregar tema e timeout', () async {
      when(() => mockPrefs.getTheme()).thenAnswer((_) async => 'dark');
      when(() => mockPrefs.getAutoLockTimeout())
          .thenAnswer((_) async => 5);

      final container = createContainer();
      await container.read(settingsProvider.notifier).loadPreferences();

      final state = container.read(settingsProvider);
      expect(state.theme, 'dark');
      expect(state.autoLockTimeout, 5);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
    });

    test('loadPreferences deve tratar erro', () async {
      when(() => mockPrefs.getTheme()).thenThrow(Exception('fail'));

      final container = createContainer();
      await container.read(settingsProvider.notifier).loadPreferences();

      final state = container.read(settingsProvider);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNotNull);
    });

    test('setTheme deve salvar e atualizar estado', () async {
      when(() => mockPrefs.setTheme(any())).thenAnswer((_) async {});
      when(() => mockPrefs.getTheme()).thenAnswer((_) async => 'light');

      final container = createContainer();
      await container.read(settingsProvider.notifier).setTheme('light');

      final state = container.read(settingsProvider);
      expect(state.theme, 'light');
      verify(() => mockPrefs.setTheme('light')).called(1);
    });

    test('setTheme deve tratar erro', () async {
      when(() => mockPrefs.setTheme(any())).thenThrow(Exception('fail'));

      final container = createContainer();
      await container.read(settingsProvider.notifier).setTheme('dark');

      final state = container.read(settingsProvider);
      expect(state.errorMessage, isNotNull);
    });

    test('setAutoLockTimeout deve salvar e atualizar estado', () async {
      when(() => mockPrefs.setAutoLockTimeout(any()))
          .thenAnswer((_) async {});

      final container = createContainer();
      await container
          .read(settingsProvider.notifier)
          .setAutoLockTimeout(10);

      final state = container.read(settingsProvider);
      expect(state.autoLockTimeout, 10);
      verify(() => mockPrefs.setAutoLockTimeout(10)).called(1);
    });

    test('setAutoLockTimeout deve tratar erro', () async {
      when(() => mockPrefs.setAutoLockTimeout(any()))
          .thenThrow(Exception('fail'));

      final container = createContainer();
      await container
          .read(settingsProvider.notifier)
          .setAutoLockTimeout(5);

      final state = container.read(settingsProvider);
      expect(state.errorMessage, isNotNull);
    });
  });
}
