import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/domain/services/password_generator_service.dart';

void main() {
  late PasswordGeneratorService generator;

  setUp(() {
    generator = PasswordGeneratorService();
  });

  group('PasswordGeneratorService', () {
    group('generatePassword', () {
      test('deve gerar senha com tamanho correto', () {
        final password = generator.generatePassword(
          length: 16,
          uppercase: true,
          lowercase: true,
          digits: true,
          symbols: false,
          excludeAmbiguous: false,
        );
        expect(password.length, 16);
      });

      test('deve gerar senha com tamanho mínimo (8)', () {
        final password = generator.generatePassword(
          length: 8,
          uppercase: true,
          lowercase: true,
          digits: false,
          symbols: false,
          excludeAmbiguous: false,
        );
        expect(password.length, 8);
      });

      test('deve gerar senha com tamanho máximo (64)', () {
        final password = generator.generatePassword(
          length: 64,
          uppercase: true,
          lowercase: true,
          digits: true,
          symbols: true,
          excludeAmbiguous: false,
        );
        expect(password.length, 64);
      });

      test('deve lançar exceção quando tamanho < 8', () {
        expect(
          () => generator.generatePassword(
            length: 7,
            uppercase: true,
            lowercase: true,
            digits: false,
            symbols: false,
            excludeAmbiguous: false,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('deve lançar exceção quando tamanho > 64', () {
        expect(
          () => generator.generatePassword(
            length: 65,
            uppercase: true,
            lowercase: true,
            digits: false,
            symbols: false,
            excludeAmbiguous: false,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('deve lançar exceção quando nenhum tipo habilitado', () {
        expect(
          () => generator.generatePassword(
            length: 16,
            uppercase: false,
            lowercase: false,
            digits: false,
            symbols: false,
            excludeAmbiguous: false,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('deve gerar senha apenas com maiúsculas quando apenas uppercase habilitado', () {
        final password = generator.generatePassword(
          length: 20,
          uppercase: true,
          lowercase: false,
          digits: false,
          symbols: false,
          excludeAmbiguous: false,
        );
        expect(password.length, 20);
        expect(password, matches(RegExp(r'^[A-Z]+$')));
      });

      test('deve gerar senha apenas com minúsculas quando apenas lowercase habilitado', () {
        final password = generator.generatePassword(
          length: 20,
          uppercase: false,
          lowercase: true,
          digits: false,
          symbols: false,
          excludeAmbiguous: false,
        );
        expect(password.length, 20);
        expect(password, matches(RegExp(r'^[a-z]+$')));
      });

      test('deve gerar senha apenas com dígitos quando apenas digits habilitado', () {
        final password = generator.generatePassword(
          length: 20,
          uppercase: false,
          lowercase: false,
          digits: true,
          symbols: false,
          excludeAmbiguous: false,
        );
        expect(password.length, 20);
        expect(password, matches(RegExp(r'^[0-9]+$')));
      });

      test('deve gerar senha apenas com símbolos quando apenas symbols habilitado', () {
        final password = generator.generatePassword(
          length: 20,
          uppercase: false,
          lowercase: false,
          digits: false,
          symbols: true,
          excludeAmbiguous: false,
        );
        expect(password.length, 20);
        // Símbolos não devem conter letras ou dígitos
        expect(password, isNot(RegExp(r'[a-zA-Z0-9]').hasMatch(password)));
      });

      test('deve excluir caracteres ambíguos quando flag ativa', () {
        final ambiguousChars = {'0', 'O', 'l', '1', 'I'};
        // Gerar várias vezes para ter certeza
        for (var i = 0; i < 100; i++) {
          final password = generator.generatePassword(
            length: 20,
            uppercase: true,
            lowercase: true,
            digits: true,
            symbols: false,
            excludeAmbiguous: true,
          );
          for (final char in password.split('')) {
            expect(
              ambiguousChars.contains(char),
              false,
              reason: 'Caractere ambíguo "$char" encontrado na senha',
            );
          }
        }
      });

      test('deve incluir caracteres ambíguos quando flag desativa', () {
        // Gerar com todos os tipos para maximizar chance de ambíguos
        final passwords = <String>[];
        for (var i = 0; i < 200; i++) {
          passwords.add(generator.generatePassword(
            length: 64,
            uppercase: true,
            lowercase: true,
            digits: true,
            symbols: false,
            excludeAmbiguous: false,
          ));
        }
        // Pelo menos uma senha deve conter um caractere ambíguo
        final hasAmbiguous = passwords.any((p) {
          for (final char in p.split('')) {
            if ({'0', 'O', 'l', '1', 'I'}.contains(char)) return true;
          }
          return false;
        });
        expect(hasAmbiguous, true);
      });

      test('senhas geradas devem ser aleatórias (diferentes entre si)', () {
        final passwords = <String>{};
        for (var i = 0; i < 10; i++) {
          passwords.add(generator.generatePassword(
            length: 16,
            uppercase: true,
            lowercase: true,
            digits: true,
            symbols: false,
            excludeAmbiguous: false,
          ));
        }
        // Todas as 10 senhas devem ser únicas
        expect(passwords.length, 10);
      });
    });
  });
}
