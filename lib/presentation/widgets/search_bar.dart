import 'package:flutter/material.dart';

/// Widget reutilizavel da barra de pesquisa.
///
/// Exibe: campo de texto, icone de busca, botao de limpar.
/// Design limpo e funcional seguindo UI_UX_GUIDE.md.
class VaultSearchBar extends StatefulWidget {
  /// Callback chamado quando o texto muda.
  final ValueChanged<String>? onChanged;

  /// Callback chamado quando o botao de limpar e pressionado.
  final VoidCallback? onClear;

  /// Texto inicial do campo.
  final String? initialValue;

  /// Hint text do campo.
  final String? hintText;

  /// Se o campo esta habilitado.
  final bool enabled;

  const VaultSearchBar({
    super.key,
    this.onChanged,
    this.onClear,
    this.initialValue,
    this.hintText,
    this.enabled = true,
  });

  @override
  State<VaultSearchBar> createState() => _VaultSearchBarState();
}

class _VaultSearchBarState extends State<VaultSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(VaultSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Buscar senhas...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  onPressed: _handleClear,
                  icon: Icon(
                    Icons.clear_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Limpar busca',
                  visualDensity: VisualDensity.compact,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
