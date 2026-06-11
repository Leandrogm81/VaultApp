/// Smoke test — valida que o projeto compila e componentes basicos existem.
///
/// Este teste NAO valida funcionalidade de negocio (ainda nao existe).
/// Valida que:
/// - O projeto compila sem erros de importacao.
/// - O widget principal pode ser instanciado.
/// - A estrutura basica do app esta correta.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/main.dart';

void main() {
  group('Smoke test — VaultApp', () {
    test('VaultApp pode ser instanciado', () {
      // Verifica que o widget principal existe e pode ser criado.
      const app = VaultApp();
      expect(app, isNotNull);
      expect(app, isA<VaultApp>());
    });

    test('VaultApp tem key correta', () {
      const app = VaultApp(key: Key('test_app'));
      expect(app.key, isA<Key>());
    });

    test('Projeto compila — importacoes resolvidas', () {
      // Se este teste executa, significa que todas as importacoes
      // em main.dart foram resolvidas com sucesso.
      expect(true, isTrue);
    });
  });
}
