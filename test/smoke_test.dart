/// Smoke test — valida que o projeto compila e componentes básicos existem.
///
/// Este teste NÃO valida funcionalidade de negócio (ainda não existe).
/// Valida que:
/// - O projeto compila sem erros de importação.
/// - O widget principal pode ser instanciado.
/// - A estrutura básica do app está correta.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/main.dart';

void main() {
  group('Smoke test — VaultApp', () {
    test('MyApp pode ser instanciado', () {
      // Verifica que o widget principal existe e pode ser criado.
      const app = MyApp();
      expect(app, isNotNull);
      expect(app, isA<MyApp>());
    });

    test('MyApp tem key correta', () {
      const app = MyApp(key: Key('test_app'));
      expect(app.key, isA<Key>());
    });

    test('Projeto compila — importações resolvidas', () {
      // Se este teste executa, significa que todas as importações
      // em main.dart foram resolvidas com sucesso.
      expect(true, isTrue);
    });
  });
}
