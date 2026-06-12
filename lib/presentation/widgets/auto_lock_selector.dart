import 'package:flutter/material.dart';

import '../../domain/services/auto_lock_service.dart';

/// Widget de selecao de auto-lock timeout.
///
/// Exibe opcoes de timeout como lista de tiles clicaveis.
/// Segue /docs/design/UI_UX_GUIDE.md: clareza, hierarquia, sem aparencia de IA.
class AutoLockSelector extends StatelessWidget {
  /// Timeout atual selecionado (em minutos).
  final int currentTimeout;

  /// Callback ao mudar o timeout.
  final ValueChanged<int> onChanged;

  const AutoLockSelector({
    super.key,
    required this.currentTimeout,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = AutoLockService.getTimeoutOptions();

    return RadioGroup<int>(
      groupValue: currentTimeout,
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      child: Column(
        children: options.map((minutes) {
          final isSelected = minutes == currentTimeout;
          final label = AutoLockService.formatTimeout(minutes);

          return RadioListTile<int>(
            title: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: minutes == 0
                ? Text(
                    'O app nunca bloqueia automaticamente',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            value: minutes,
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            dense: true,
          );
        }).toList(),
      ),
    );
  }
}
