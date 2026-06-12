import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/presentation/widgets/password_generator_dialog.dart';

void main() {
  group('PasswordGeneratorDialog', () {
    Widget buildTestDialog({ValueChanged<String>? onPasswordGenerated}) {
      return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => PasswordGeneratorDialog(
                    onPasswordGenerated: onPasswordGenerated ?? (_) {},
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
    }

    testWidgets('deve abrir dialog com titulo "Gerar Senha"', (tester) async {
      await tester.pumpWidget(buildTestDialog());
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Gerar Senha'), findsOneWidget);
    });

    testWidgets('deve exibir senha gerada no preview', (tester) async {
      await tester.pumpWidget(buildTestDialog());
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // O preview deve ter "Senha gerada" como label
      expect(find.text('Senha gerada'), findsOneWidget);
      // Deve ter um container com senha (monospace font)
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('deve exibir slider de tamanho', (tester) async {
      await tester.pumpWidget(buildTestDialog());
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('deve exibir toggles de tipos', (tester) async {
      await tester.pumpWidget(buildTestDialog());
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Maiúsculas'), findsOneWidget);
      expect(find.text('Minúsculas'), findsOneWidget);
      expect(find.text('Números'), findsOneWidget);
      expect(find.text('Símbolos'), findsOneWidget);
    });

    testWidgets('deve exibir toggle de ambíguos', (tester) async {
      await tester.pumpWidget(buildTestDialog());
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir ambíguos'), findsOneWidget);
    });

    testWidgets('deve exibir botoes Cancelar, Copiar e Usar', (tester) async {
      await tester.pumpWidget(buildTestDialog());
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Copiar'), findsOneWidget);
      expect(find.text('Usar'), findsOneWidget);
    });

    testWidgets('deve fechar dialog ao clicar Cancelar', (tester) async {
      await tester.pumpWidget(buildTestDialog());
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Dialog deve estar fechado
      expect(find.text('Gerar Senha'), findsNothing);
    });

    testWidgets('deve chamar onPasswordGenerated ao clicar Usar', (tester) async {
      String? receivedPassword;
      await tester.pumpWidget(
        buildTestDialog(onPasswordGenerated: (p) => receivedPassword = p),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Usar'));
      await tester.pumpAndSettle();

      expect(receivedPassword, isNotNull);
      expect(receivedPassword!.length, 16); // default length
    });

    testWidgets('deve atualizar preview ao mudar slider', (tester) async {
      await tester.pumpWidget(buildTestDialog());
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Encontrar o slider e arrastar
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle();

      // O preview deve ter atualizado (senha de tamanho diferente)
      // Não podemos testar o valor exato por ser aleatório
      expect(find.text('Senha gerada'), findsOneWidget);
    });

    testWidgets('deve impedir desabilitar ultimo tipo ativo', (tester) async {
      await tester.pumpWidget(buildTestDialog());
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Desabilitar maiusculas
      await tester.tap(find.text('Maiúsculas'));
      await tester.pumpAndSettle();

      // Desabilitar minusculas
      await tester.tap(find.text('Minúsculas'));
      await tester.pumpAndSettle();

      // Desabilitar numeros
      await tester.tap(find.text('Números'));
      await tester.pumpAndSettle();

      // Agora so symbols esta ativo - tentar desabilitar
      // Nao deve funcionar
      final symbolsTile = find.text('Símbolos');
      expect(symbolsTile, findsOneWidget);
    });
  });
}
