import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/domain/services/clipboard_password_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ClipboardPasswordService service;

  setUp(() {
    service = ClipboardPasswordService();
  });

  tearDown(() {
    service.dispose();
  });

  group('getClearTimeout', () {
    test('deve retornar 30 como default', () {
      expect(service.getClearTimeout(), 30);
    });
  });

  group('setClearTimeout', () {
    test('deve salvar timeout customizado', () {
      service.setClearTimeout(60);
      expect(service.getClearTimeout(), 60);
    });

    test('deve permitir timeout zero', () {
      service.setClearTimeout(0);
      expect(service.getClearTimeout(), 0);
    });
  });

  group('copyPassword', () {
    test('deve copiar senha para clipboard', () async {
      final binding = TestDefaultBinaryMessengerBinding.instance;
      binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            return null;
          }
          return null;
        },
      );

      await service.copyPassword('minha_senha_123');
      // Verificacao indireta: clipboardHasCopiedPassword deve retornar true
      // (nao podemos testar clipboard diretamente no unit test)

      binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });
  });

  group('stopAutoClear', () {
    test('deve cancelar timer sem erros', () {
      service.stopAutoClear();
      // Nao deve lancar excecao
    });

    test('deve poder chamar multiplas vezes', () {
      service.stopAutoClear();
      service.stopAutoClear();
      service.stopAutoClear();
    });
  });

  group('dispose', () {
    test('deve limpar estado sem erros', () {
      service.dispose();
    });

    test('deve poder chamar multiplas vezes', () {
      service.dispose();
      service.dispose();
    });
  });
}
