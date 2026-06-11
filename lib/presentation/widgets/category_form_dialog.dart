import 'package:flutter/material.dart';

import '../../domain/entities/category.dart';

/// Dialog reutilizavel para criar ou editar categoria.
///
/// Campo nome (obrigatorio), picker de icone (Material Icons),
/// picker de cor (paleta). Segue UI/UX Guide para dialogos.
class CategoryFormDialog extends StatefulWidget {
  /// Categoria existente para edicao (null para criacao).
  final Category? existingCategory;

  const CategoryFormDialog({super.key, this.existingCategory});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  late final TextEditingController _nameController;
  String _selectedIcon = 'other';
  int _selectedColor = 0xFF1D4ED8; // Primaria padrao

  bool get _isEditing => widget.existingCategory != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingCategory?.name ?? '',
    );
    _selectedIcon = widget.existingCategory?.icon ?? 'other';
    _selectedColor = widget.existingCategory?.color ?? 0xFF1D4ED8;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar Categoria' : 'Criar Categoria',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo nome
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Nome *',
                hintText: 'Ex: Social, Banco',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // Picker de icone
            Text(
              'Icone',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _buildIconPicker(colorScheme),
            const SizedBox(height: 20),

            // Picker de cor
            Text(
              'Cor',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _buildColorPicker(colorScheme),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _nameController.text.trim().isEmpty
              ? null
              : () {
                  final category = Category(
                    id: widget.existingCategory?.id ?? '',
                    name: _nameController.text.trim(),
                    icon: _selectedIcon,
                    color: _selectedColor,
                    createdAt:
                        widget.existingCategory?.createdAt ?? DateTime.now(),
                  );
                  Navigator.of(context).pop(category);
                },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  Widget _buildIconPicker(ColorScheme colorScheme) {
    final icons = <MapEntry<String, IconData>>[
      const MapEntry('social', Icons.people_rounded),
      const MapEntry('email', Icons.mail_rounded),
      const MapEntry('bank', Icons.account_balance_rounded),
      const MapEntry('shopping', Icons.shopping_cart_rounded),
      const MapEntry('work', Icons.work_rounded),
      const MapEntry('other', Icons.more_horiz_rounded),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: icons.map((entry) {
        final isSelected = _selectedIcon == entry.key;
        return InkWell(
          onTap: () => setState(() => _selectedIcon = entry.key),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              entry.value,
              size: 20,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorPicker(ColorScheme colorScheme) {
    final colors = <MapEntry<String, int>>[
      const MapEntry('Azul', 0xFF1D4ED8),
      const MapEntry('Verde', 0xFF15803D),
      const MapEntry('Vermelho', 0xFFB91C1C),
      const MapEntry('Amarelo', 0xFFB45309),
      const MapEntry('Roxo', 0xFF7C3AED),
      const MapEntry('Rosa', 0xFFDB2777),
      const MapEntry('Cinza', 0xFF64748B),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((entry) {
        final isSelected = _selectedColor == entry.value;
        return InkWell(
          onTap: () => setState(() => _selectedColor = entry.value),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(entry.value),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? colorScheme.onSurface : Colors.transparent,
                width: isSelected ? 3 : 0,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: Colors.white,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
