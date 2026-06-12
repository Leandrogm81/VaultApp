import 'dart:math';

/// Servico de geracao de senhas para o VaultApp.
///
/// Gera senhas aleatorias com parametros configuraveis:
/// - Tamanho (8-64)
/// - Tipos de caracteres (maiusculas, minusculas, numeros, simbolos)
/// - Exclusao de caracteres ambiguos (0, O, l, 1, I)
class PasswordGeneratorService {
  /// Caracteres considerados ambíguos.
  static const Set<String> _ambiguousChars = {'0', 'O', 'l', '1', 'I'};

  /// Conjunto de letras maiúsculas.
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Conjunto de letras minúsculas.
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';

  /// Conjunto de dígitos.
  static const String _digits = '0123456789';

  /// Conjunto de símbolos.
  static const String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  /// Tamanho mínimo da senha.
  static const int minLength = 8;

  /// Tamanho máximo da senha.
  static const int maxLength = 64;

  /// Gera uma senha aleatória com os parâmetros especificados.
  ///
  /// [length] — tamanho da senha (8-64).
  /// [uppercase] — incluir letras maiúsculas.
  /// [lowercase] — incluir letras minúsculas.
  /// [digits] — incluir dígitos.
  /// [symbols] — incluir símbolos.
  /// [excludeAmbiguous] — excluir caracteres ambíguos (0, O, l, 1, I).
  ///
  /// Lança [ArgumentError] se nenhum tipo estiver habilitado
  /// ou se o tamanho estiver fora do range válido.
  String generatePassword({
    required int length,
    required bool uppercase,
    required bool lowercase,
    required bool digits,
    required bool symbols,
    required bool excludeAmbiguous,
  }) {
    // Validar tamanho
    if (length < minLength || length > maxLength) {
      throw ArgumentError(
        'Tamanho deve ser entre $minLength e $maxLength. Recebido: $length',
      );
    }

    // Validar que pelo menos um tipo está habilitado
    if (!uppercase && !lowercase && !digits && !symbols) {
      throw ArgumentError(
        'Pelo menos um tipo de caractere deve estar habilitado',
      );
    }

    // Construir conjunto de caracteres disponíveis
    var availableChars = '';

    if (uppercase) {
      availableChars += _uppercase;
    }
    if (lowercase) {
      availableChars += _lowercase;
    }
    if (digits) {
      availableChars += _digits;
    }
    if (symbols) {
      availableChars += _symbols;
    }

    // Excluir caracteres ambíguos se solicitado
    if (excludeAmbiguous) {
      availableChars = availableChars
          .split('')
          .where((c) => !_ambiguousChars.contains(c))
          .join();
    }

    // Gerar senha aleatória
    final random = Random.secure();
    final password = List.generate(
      length,
      (_) => availableChars[random.nextInt(availableChars.length)],
    );

    return password.join();
  }
}
