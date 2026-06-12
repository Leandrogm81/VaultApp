import 'package:flutter/material.dart';

import '../../domain/services/password_generator_service.dart';
import '../../core/services/clipboard_service.dart';

/// Dialog modal para geracao de senhas.
///
/// Exibe slider de tamanho (8-64), toggles de tipos de caracteres,
/// exclusao de ambíguos, preview em tempo real, e botoes Copiar/Usar.
/// Segue UI/UX Guide para dialogos.
class PasswordGeneratorDialog extends StatefulWidget {
  /// Callback chamado quando o usuario clica "Usar".
  final ValueChanged<String> onPasswordGenerated;

  const PasswordGeneratorDialog({
    super.key,
    required this.onPasswordGenerated,
  });

  @override
  State<PasswordGeneratorDialog> createState() =>
      _PasswordGeneratorDialogState();
}

class _PasswordGeneratorDialogState extends State<PasswordGeneratorDialog> {
  final _generator = PasswordGeneratorService();
  final _clipboardService = ClipboardService();

  /// Tamanho da senha (default: 16).
  int _length = 16;

  /// Incluir maiusculas.
  bool _uppercase = true;

  /// Incluir minusculas.
  bool _lowercase = true;

  /// Incluir numeros.
  bool _digits = true;

  /// Incluir simbolos.
  bool _symbols = false;

  /// Excluir caracteres ambiguos.
  bool _excludeAmbiguous = true;

  /// Senha gerada atualmente.
  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    _regeneratePassword();
  }

  /// Regenera a senha com os parametros atuais.
  void _regeneratePassword() {
    try {
      _generatedPassword = _generator.generatePassword(
        length: _length,
        uppercase: _uppercase,
        lowercase: _lowercase,
        digits: _digits,
        symbols: _symbols,
        excludeAmbiguous: _excludeAmbiguous,
      );
    } catch (e) {
      _generatedPassword = '';
    }
  }

  /// Conta quantos tipos estão habilitados.
  int get _enabledTypeCount =>
      [_uppercase, _lowercase, _digits, _symbols]
          .where((e) => e)
          .length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: const Text(
        'Gerar Senha',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview da senha gerada
            _buildPasswordPreview(colorScheme),
            const SizedBox(height: 20),

            // Slider de tamanho
            _buildLengthSlider(colorScheme),
            const SizedBox(height: 16),

            // Toggles de tipos
            Text(
              'Tipos de caracteres',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _buildTypeToggles(colorScheme),
            const SizedBox(height: 16),

            // Toggle de ambíguos
            _buildAmbiguousToggle(colorScheme),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        OutlinedButton.icon(
          onPressed: _generatedPassword.isEmpty
              ? null
              : () async {
                  await _clipboardService.copyToClipboard(_generatedPassword);
                  if (context.mounted) {
                    _clipboardService.showCopyFeedback(context);
                  }
                },
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: const Text('Copiar'),
        ),
        FilledButton(
          onPressed: _generatedPassword.isEmpty
              ? null
              : () {
                  widget.onPasswordGenerated(_generatedPassword);
                  Navigator.of(context).pop();
                },
          child: const Text('Usar'),
        ),
      ],
    );
  }

  Widget _buildPasswordPreview(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Senha gerada',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _generatedPassword.isNotEmpty ? _generatedPassword : '—',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLengthSlider(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tamanho',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_length',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: _length.toDouble(),
          min: PasswordGeneratorService.minLength.toDouble(),
          max: PasswordGeneratorService.maxLength.toDouble(),
          divisions: PasswordGeneratorService.maxLength -
              PasswordGeneratorService.minLength,
          label: '$_length',
          onChanged: (value) {
            setState(() {
              _length = value.round();
              _regeneratePassword();
            });
          },
        ),
      ],
    );
  }

  Widget _buildTypeToggles(ColorScheme colorScheme) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Maiúsculas'),
          subtitle: const Text('A-Z'),
          value: _uppercase,
          onChanged: (value) {
            // Impedir desabilitar se for o último tipo ativo
            if (!value && _enabledTypeCount <= 1) return;
            setState(() {
              _uppercase = value;
              _regeneratePassword();
            });
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        SwitchListTile(
          title: const Text('Minúsculas'),
          subtitle: const Text('a-z'),
          value: _lowercase,
          onChanged: (value) {
            if (!value && _enabledTypeCount <= 1) return;
            setState(() {
              _lowercase = value;
              _regeneratePassword();
            });
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        SwitchListTile(
          title: const Text('Números'),
          subtitle: const Text('0-9'),
          value: _digits,
          onChanged: (value) {
            if (!value && _enabledTypeCount <= 1) return;
            setState(() {
              _digits = value;
              _regeneratePassword();
            });
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        SwitchListTile(
          title: const Text('Símbolos'),
          subtitle: const Text('!@#\$%^&*()_+-='),
          value: _symbols,
          onChanged: (value) {
            if (!value && _enabledTypeCount <= 1) return;
            setState(() {
              _symbols = value;
              _regeneratePassword();
            });
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
      ],
    );
  }

  Widget _buildAmbiguousToggle(ColorScheme colorScheme) {
    return SwitchListTile(
      title: const Text('Excluir ambíguos'),
      subtitle: const Text('0, O, l, 1, I'),
      value: _excludeAmbiguous,
      onChanged: (value) {
        setState(() {
          _excludeAmbiguous = value;
          _regeneratePassword();
        });
      },
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
