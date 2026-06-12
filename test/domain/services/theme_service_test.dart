import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaultapp/domain/services/preferences_service.dart';
import 'package:vaultapp/domain/services/theme_service.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefs;

  setUp(() {
    mockPrefs = MockPreferencesService();
  });

  group('resolveTheme', () {
    test('"light" deve resolver para ThemeMode.light', () {
      expect(ThemeService.resolveTheme('light'), ThemeMode.light);
    });

    test('"dark" deve resolver para ThemeMode.dark', () {
      expect(ThemeService.resolveTheme('dark'), ThemeMode.dark);
    });

    test('"system" deve resolver para ThemeMode.system', () {
      expect(ThemeService.resolveTheme('system'), ThemeMode.system);
    });

    test('valor invalido deve resolver para ThemeMode.system', () {
      expect(ThemeService.resolveTheme('invalid'), ThemeMode.system);
    });

    test('string vazia deve resolver para ThemeMode.system', () {
      expect(ThemeService.resolveTheme(''), ThemeMode.system);
    });
  });

  group('getThemeMode', () {
    test('deve retornar ThemeMode baseado na preferencia', () async {
      when(() => mockPrefs.getTheme()).thenAnswer((_) async => 'dark');
      final mode = await ThemeService.getThemeMode(mockPrefs);
      expect(mode, ThemeMode.dark);
    });

    test('deve retornar system quando preferencia e system', () async {
      when(() => mockPrefs.getTheme()).thenAnswer((_) async => 'system');
      final mode = await ThemeService.getThemeMode(mockPrefs);
      expect(mode, ThemeMode.system);
    });

    test('deve retornar light quando preferencia e light', () async {
      when(() => mockPrefs.getTheme()).thenAnswer((_) async => 'light');
      final mode = await ThemeService.getThemeMode(mockPrefs);
      expect(mode, ThemeMode.light);
    });
  });
}
