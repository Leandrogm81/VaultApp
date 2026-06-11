import 'package:flutter/material.dart';

/// Dialog de confirmacao reutilizavel para acoes destrutivas.
///
/// Segue UI/UX Guide: botao destrutivo em vermelho, texto claro.
class ConfirmDialog extends StatelessWidget {
  /// Titulo do dialog.
  final String title;

  /// Mensagem de confirmacao.
  final String message;

  /// Texto do botao de confirmacao.
  final String confirmLabel;

  /// Texto do botao de cancelamento.
  final String cancelLabel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

/// Exibe um dialog de confirmacao e retorna um Future<bool>.
///
/// true = confirmado, false = cancelado.
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );
  return result ?? false;
}
