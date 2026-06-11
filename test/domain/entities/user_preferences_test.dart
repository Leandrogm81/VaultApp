import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/domain/entities/user_preferences.dart';

void main() {
  group('UserPreferences', () {
    test('deve ter valores padrao corretos', () {
      final prefs = UserPreferences.defaults();

      expect(prefs.theme, 'system');
      expect(prefs.autoLockTimeout, 2);
      expect(prefs.autoWipeThreshold, 10);
      expect(prefs.backupReminderDays, 7);
    });

    test('deve aceitar todos os campos customizados', () {
      final prefs = UserPreferences(
        theme: 'dark',
        autoLockTimeout: 5,
        autoWipeThreshold: 15,
        backupReminderDays: 14,
      );

      expect(prefs.theme, 'dark');
      expect(prefs.autoLockTimeout, 5);
      expect(prefs.autoWipeThreshold, 15);
      expect(prefs.backupReminderDays, 14);
    });

    test('copyWith deve criar copia com campos alterados', () {
      final original = UserPreferences.defaults();
      final copy = original.copyWith(theme: 'dark');

      expect(copy.theme, 'dark');
      expect(copy.autoLockTimeout, 2); // preservado
    });

    test('copyWith deve preservar campos nao informados', () {
      final original = UserPreferences(
        theme: 'light',
        autoLockTimeout: 10,
        autoWipeThreshold: 20,
        backupReminderDays: 30,
      );

      final copy = original.copyWith(autoLockTimeout: 5);

      expect(copy.theme, 'light');
      expect(copy.autoWipeThreshold, 20);
      expect(copy.backupReminderDays, 30);
    });
  });
}
