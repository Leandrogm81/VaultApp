import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaultapp/domain/services/auto_lock_service.dart';
import 'package:vaultapp/domain/services/preferences_service.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefs;

  setUp(() {
    mockPrefs = MockPreferencesService();
  });

  group('AutoLockService', () {
    group('getTimeout', () {
      test('deve retornar timeout do PreferencesService', () async {
        when(() => mockPrefs.getAutoLockTimeout())
            .thenAnswer((_) async => 5);
        final timeout = await AutoLockService.getTimeout(mockPrefs);
        expect(timeout, 5);
      });
    });

    group('setTimeout', () {
      test('deve salvar timeout via PreferencesService', () async {
        when(() => mockPrefs.setAutoLockTimeout(any()))
            .thenAnswer((_) async {});
        await AutoLockService.setTimeout(mockPrefs, 10);
        verify(() => mockPrefs.setAutoLockTimeout(10)).called(1);
      });
    });

    group('getTimeoutOptions', () {
      test('deve retornar [1, 2, 5, 10, 0]', () {
        final options = AutoLockService.getTimeoutOptions();
        expect(options, [1, 2, 5, 10, 0]);
      });
    });

    group('formatTimeout', () {
      test('0 deve formatar como "Nunca"', () {
        expect(AutoLockService.formatTimeout(0), 'Nunca');
      });

      test('1 deve formatar como "1 min"', () {
        expect(AutoLockService.formatTimeout(1), '1 min');
      });

      test('2 deve formatar como "2 min"', () {
        expect(AutoLockService.formatTimeout(2), '2 min');
      });

      test('5 deve formatar como "5 min"', () {
        expect(AutoLockService.formatTimeout(5), '5 min');
      });

      test('10 deve formatar como "10 min"', () {
        expect(AutoLockService.formatTimeout(10), '10 min');
      });
    });
  });
}
