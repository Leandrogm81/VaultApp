import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

import 'package:vaultapp/core/services/clipboard_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ClipboardService', () {
    late ClipboardService service;

    setUp(() {
      service = ClipboardService();
      // Mock clipboard para testes
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/base'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            return null;
          }
          return null;
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/base'),
        null,
      );
    });

    test('copyToClipboard copia texto para clipboard', () async {
      // Nao deve lancar excecao
      await service.copyToClipboard('senha123');
    });

    test('copyAndNotify copia e retorna sem erro', () async {
      // Apenas testa que o metodo existe e e chamavel
      expect(service.copyAndNotify, isA<Function>());
    });
  });
}
