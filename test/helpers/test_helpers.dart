/// Helpers compartilhados para testes do VaultApp.
///
/// Contém utilitários reutilizáveis para setup de testes unitários
/// e de widget. Novos helpers devem ser adicionados aqui conforme
/// as sprints implementam funcionalidades.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Retorna um [MaterialApp] wrapper adequado para testes de widget.
///
/// Usa [child] como corpo. Útil para testar widgets isolados
/// sem precisar do app completo.
MaterialApp buildTestApp({required Widget child}) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

/// Extensão em [WidgetTester] para aguardar animações.
extension WidgetTesterExtensions on WidgetTester {
  /// Aguarda todas as animações e microtasks pendentes serem processadas.
  Future<void> pumpAndSettleWithTimeout({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await pumpAndSettle(timeout);
  }
}
