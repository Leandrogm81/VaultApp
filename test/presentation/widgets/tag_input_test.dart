import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/presentation/widgets/tag_input.dart';

void main() {
  Widget buildTestApp({Widget? child}) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: child ?? const TagInput(),
        ),
      ),
    );
  }

  group('TagInput', () {
    testWidgets('deve renderizar campo de texto', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Adicionar tag...'), findsOneWidget);
    });

    testWidgets('deve exibir tags existentes como chips', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const TagInput(tags: ['work', 'dev']),
        ),
      );
      expect(find.text('work'), findsOneWidget);
      expect(find.text('dev'), findsOneWidget);
    });

    testWidgets('deve mostrar contador de tags', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const TagInput(tags: ['work', 'dev']),
        ),
      );
      expect(find.text('2/10 tags'), findsOneWidget);
    });

    testWidgets('deve esconder contador quando nao ha tags', (tester) async {
      await tester.pumpWidget(buildTestApp());
      expect(find.text('0/10 tags'), findsNothing);
    });

    testWidgets('deve adicionar tag ao pressionar Enter', (tester) async {
      List<String> updatedTags = [];
      await tester.pumpWidget(
        buildTestApp(
          child: TagInput(
            onTagsChanged: (tags) => updatedTags = tags,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'work');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(updatedTags, ['work']);
    });

    testWidgets('nao deve adicionar tag duplicada', (tester) async {
      List<String> updatedTags = ['work'];
      await tester.pumpWidget(
        buildTestApp(
          child: TagInput(
            tags: ['work'],
            onTagsChanged: (tags) => updatedTags = tags,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'work');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(updatedTags.length, 1);
    });

    testWidgets('deve remover tag ao clicar no X', (tester) async {
      List<String> updatedTags = ['work', 'dev'];
      await tester.pumpWidget(
        buildTestApp(
          child: TagInput(
            tags: ['work', 'dev'],
            onTagsChanged: (tags) => updatedTags = tags,
          ),
        ),
      );
      // Encontra e clica no botao de deletar do chip "work"
      final workChip = find.widgetWithText(Chip, 'work');
      await tester.tap(find.descendant(
        of: workChip,
        matching: find.byIcon(Icons.close_rounded),
      ));
      await tester.pump();
      expect(updatedTags, ['dev']);
    });

    testWidgets('deve desabilitar campo quando limite atingido',
        (tester) async {
      final tags = List.generate(10, (i) => 'tag$i');
      await tester.pumpWidget(
        buildTestApp(
          child: TagInput(tags: tags),
        ),
      );
      // Campo de texto nao deve estar presente quando no limite
      expect(find.byType(TextField), findsNothing);
      expect(find.text('10/10 tags'), findsOneWidget);
    });

    testWidgets('deve mostrar sugestoes de autocomplete', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const TagInput(
            suggestions: ['work', 'dev', 'personal'],
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'wo');
      await tester.pump();
      expect(find.text('work'), findsOneWidget);
    });

    testWidgets('deve esconder sugestoes quando campo vazio', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const TagInput(
            suggestions: ['work', 'dev'],
          ),
        ),
      );
      expect(find.text('work'), findsNothing);
      expect(find.text('dev'), findsNothing);
    });

    testWidgets('deve respeitar estado enabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const TagInput(
            tags: ['work'],
            enabled: false,
          ),
        ),
      );
      expect(find.byType(TextField), findsNothing);
      // Chip deve existir mas sem botao de deletar
      expect(find.text('work'), findsOneWidget);
    });

    testWidgets('deve adicionar tag ao selecionar sugestao', (tester) async {
      List<String> updatedTags = [];
      await tester.pumpWidget(
        buildTestApp(
          child: TagInput(
            suggestions: ['work', 'dev'],
            onTagsChanged: (tags) => updatedTags = tags,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'wo');
      await tester.pump();
      await tester.tap(find.text('work'));
      await tester.pump();
      expect(updatedTags, ['work']);
    });
  });
}
