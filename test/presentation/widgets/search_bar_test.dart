import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/presentation/widgets/search_bar.dart';

void main() {
  Widget buildTestApp({Widget? child}) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: child ?? const VaultSearchBar(),
        ),
      ),
    );
  }

  group('VaultSearchBar', () {
    testWidgets('deve renderizar com hint padrao', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.text('Buscar senhas...'), findsOneWidget);
    });

    testWidgets('deve mostrar botao de limpar quando ha texto', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();
      expect(find.byIcon(Icons.clear_rounded), findsOneWidget);
    });

    testWidgets('deve esconder botao de limpar quando campo vazio',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.byIcon(Icons.clear_rounded), findsNothing);
    });

    testWidgets('deve chamar onChanged ao digitar', (tester) async {
      String changedValue = '';
      await tester.pumpWidget(
        buildTestApp(
          child: VaultSearchBar(
            onChanged: (value) => changedValue = value,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'github');
      expect(changedValue, 'github');
    });

    testWidgets('deve chamar onClear ao pressionar botao limpar',
        (tester) async {
      bool cleared = false;
      await tester.pumpWidget(
        buildTestApp(
          child: VaultSearchBar(
            onClear: () => cleared = true,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.clear_rounded));
      expect(cleared, true);
    });

    testWidgets('deve usar hintText personalizado', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const VaultSearchBar(hintText: 'Pesquisar...'),
        ),
      );
      expect(find.text('Pesquisar...'), findsOneWidget);
    });

    testWidgets('deve respeitar estado enabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const VaultSearchBar(enabled: false),
        ),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, false);
    });

    testWidgets('deve aceitar initialValue', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const VaultSearchBar(initialValue: 'github'),
        ),
      );
      expect(find.text('github'), findsOneWidget);
      expect(find.byIcon(Icons.clear_rounded), findsOneWidget);
    });
  });
}
