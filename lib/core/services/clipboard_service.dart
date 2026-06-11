import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Servico de copiar texto para o clipboard com feedback visual.
///
/// Usado na lista e no detalhe de senhas.
/// Segue UI/UX Guide para mensagens de sucesso.
class ClipboardService {
  /// Copia texto para o clipboard.
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Exibe SnackBar de feedback apos copiar.
  ///
  /// Segue UI/UX Guide: cor de sucesso, 2 segundos, texto claro.
  void showCopyFeedback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copiado para a area de transferencia'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: const Color(0xFF15803D), // success color
      ),
    );
  }

  /// Copia texto e exibe feedback em uma unica chamada.
  Future<void> copyAndNotify(BuildContext context, String text) async {
    await copyToClipboard(text);
    if (context.mounted) {
      showCopyFeedback(context);
    }
  }
}
