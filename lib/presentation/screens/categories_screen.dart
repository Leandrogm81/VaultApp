import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/categories_viewmodel.dart';
import '../widgets/category_form_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../../domain/entities/category.dart';
import '../../domain/services/category_service.dart';

/// Tela de categorias com CRUD completo.
///
/// Exibe lista de categorias (icone, nome, contagem), botao "+" para criar,
/// swipe para excluir, tap para editar. Segue UI/UX Guide.
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoriesProvider.notifier).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoriesState = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categorias',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () => _showCreateDialog(context),
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Criar categoria',
          ),
        ],
      ),
      body: _buildBody(categoriesState, colorScheme, theme),
    );
  }

  Widget _buildBody(
    CategoriesState state,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    // Estado: loading
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Estado: erro
    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {
                  ref.read(categoriesProvider.notifier).loadCategories();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    // Estado: vazio
    if (state.categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_rounded,
                size: 64,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhuma categoria criada',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Crie categorias para organizar suas senhas',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Estado: lista populada
    return RefreshIndicator(
      onRefresh: () => ref.read(categoriesProvider.notifier).loadCategories(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final item = state.categories[index];
          return _buildCategoryItem(item, colorScheme, theme);
        },
      ),
    );
  }

  Widget _buildCategoryItem(
    CategoryWithCount item,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final category = item.category;
    final iconData = _getIconData(category.icon);
    final categoryColor = category.color != null
        ? Color(category.color!)
        : colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showEditDialog(context, category),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icone da categoria
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  iconData,
                  size: 20,
                  color: categoryColor,
                ),
              ),
              const SizedBox(width: 12),

              // Nome e contagem
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.count} ${item.count == 1 ? 'senha' : 'senhas'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Botao excluir
              IconButton(
                onPressed: () => _confirmDelete(context, category),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: colorScheme.error,
                ),
                tooltip: 'Excluir categoria',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog<Category>(
      context: context,
      builder: (context) => const CategoryFormDialog(),
    ).then((category) {
      if (category != null) {
        ref.read(categoriesProvider.notifier).createCategory(
              name: category.name,
              icon: category.icon,
              color: category.color,
            );
      }
    });
  }

  void _showEditDialog(BuildContext context, Category category) {
    showDialog<Category>(
      context: context,
      builder: (context) => CategoryFormDialog(
        existingCategory: category,
      ),
    ).then((updated) {
      if (updated != null) {
        ref.read(categoriesProvider.notifier).updateCategory(
              id: category.id,
              name: updated.name,
              icon: updated.icon,
              color: updated.color,
            );
      }
    });
  }

  void _confirmDelete(BuildContext context, Category category) {
    showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Excluir categoria',
        message:
            'Deseja excluir "${category.name}"? As senhas vinculadas nao serao removidas.',
        confirmLabel: 'Excluir',
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(categoriesProvider.notifier).deleteCategory(category.id);
      }
    });
  }

  IconData _getIconData(String? icon) {
    if (icon == null) return Icons.category_rounded;
    switch (icon) {
      case 'social':
        return Icons.people_rounded;
      case 'email':
        return Icons.mail_rounded;
      case 'bank':
        return Icons.account_balance_rounded;
      case 'shopping':
        return Icons.shopping_cart_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'other':
        return Icons.more_horiz_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
