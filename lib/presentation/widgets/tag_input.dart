import 'package:flutter/material.dart';

/// Widget de chip input para tags com autocomplete.
///
/// Exibe: campo de texto, lista de chips removiveis, autocomplete,
/// limite de 10 tags, contador visual.
/// Segue UI/UX Guide.
class TagInput extends StatefulWidget {
  /// Lista atual de tags.
  final List<String> tags;

  /// Callback quando tags mudam.
  final ValueChanged<List<String>>? onTagsChanged;

  /// Sugestoes de autocomplete (tags existentes no vault).
  final List<String> suggestions;

  /// Limite maximo de tags.
  final int maxTags;

  /// Se o campo esta habilitado.
  final bool enabled;

  const TagInput({
    super.key,
    this.tags = const [],
    this.onTagsChanged,
    this.suggestions = const [],
    this.maxTags = 10,
    this.enabled = true,
  });

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  late final TextEditingController _controller;
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didUpdateWidget(TagInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tags != oldWidget.tags) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isAtLimit => widget.tags.length >= widget.maxTags;

  void _addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty) return;
    if (widget.tags.contains(trimmed)) return;
    if (_isAtLimit) return;

    final newTags = [...widget.tags, trimmed];
    widget.onTagsChanged?.call(newTags);
    _controller.clear();
    setState(() {
      _showSuggestions = false;
      _filteredSuggestions = [];
    });
  }

  void _removeTag(String tag) {
    final newTags = [...widget.tags]..remove(tag);
    widget.onTagsChanged?.call(newTags);
  }

  void _updateSuggestions(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _filteredSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    final filtered = widget.suggestions
        .where(
          (s) =>
              s.toLowerCase().contains(query.toLowerCase()) &&
              !widget.tags.contains(s),
        )
        .toList();

    setState(() {
      _filteredSuggestions = filtered;
      _showSuggestions = filtered.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Chips existentes
        if (widget.tags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: widget.tags.map((tag) {
              return Chip(
                label: Text(
                  tag,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                deleteIcon: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                onDeleted: widget.enabled ? () => _removeTag(tag) : null,
                backgroundColor: colorScheme.surfaceContainerHighest,
                side: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
        // Campo de texto com autocomplete
        if (!_isAtLimit && widget.enabled)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                onChanged: _updateSuggestions,
                onSubmitted: (value) {
                  _addTag(value);
                },
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Adicionar tag...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.label_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  isDense: true,
                ),
              ),
              // Sugestoes de autocomplete
              if (_showSuggestions)
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _filteredSuggestions[index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            suggestion,
                            style: theme.textTheme.bodyMedium,
                          ),
                          leading: Icon(
                            Icons.label_rounded,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onTap: () {
                            _addTag(suggestion);
                            _controller.clear();
                          },
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        // Contador de tags
        if (widget.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${widget.tags.length}/${widget.maxTags} tags',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _isAtLimit
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
