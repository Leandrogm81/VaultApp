import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import '../widgets/password_list_item.dart';
import '../widgets/search_bar.dart';
import '../../core/services/clipboard_service.dart';

/// Tela principal do VaultApp — lista de senhas.
///
/// Exibe: AppBar, barra de pesquisa, toggle favoritos, lista de senhas
/// (ListView.builder), FAB "+", estados: loading, vazio, erro.
/// Segue UI/UX Guide.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _clipboardService = ClipboardService();

  @override
  void initState() {
    super.initState();
    // Carrega senhas ao inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).loadPasswords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final homeState = ref.watch(homeProvider);
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VaultApp',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: VaultSearchBar(
              onChanged: (query) {
                ref.read(searchProvider.notifier).search(query);
              },
              onClear: () {
                ref.read(searchProvider.notifier).clearSearch();
              },
            ),
          ),
          // Toggle de favoritos (apenas quando busca nao esta ativa)
          if (!searchState.isActive)
            _buildFavoritesToggle(homeState, colorScheme, theme),
          // Conteudo principal
          Expanded(
            child: searchState.isActive
                ? _buildSearchBody(searchState, colorScheme, theme)
                : _buildBody(homeState, colorScheme, theme),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/password/new');
        },
        tooltip: 'Adicionar senha',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildFavoritesToggle(
    HomeState state,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Botao "Todas"
          _buildFilterChip(
            label: 'Todas',
            isSelected: !state.showFavoritesOnly,
            onTap: () {
              if (state.showFavoritesOnly) {
                ref.read(homeProvider.notifier).toggleFavoritesFilter();
              }
            },
            colorScheme: colorScheme,
            theme: theme,
          ),
          const SizedBox(width: 8),
          // Botao "Favoritas"
          _buildFilterChip(
            label: 'Favoritas',
            isSelected: state.showFavoritesOnly,
            onTap: () {
              if (!state.showFavoritesOnly) {
                ref.read(homeProvider.notifier).toggleFavoritesFilter();
              }
            },
            colorScheme: colorScheme,
            theme: theme,
            icon: Icons.star_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required ThemeData theme,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Corpo para resultados de busca.
  Widget _buildSearchBody(
    SearchState state,
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
            ],
          ),
        ),
      );
    }

    // Estado: sem resultados
    if (state.results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum resultado',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nenhum resultado para "${state.query}"',
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

    // Estado: resultados encontrados
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final password = state.results[index];
        return PasswordListItem(
          password: password,
          onTap: () async {
            final result = await context.push('/password/${password.id}');
            if (result == true) {
              ref.read(homeProvider.notifier).refresh();
              // Reexecuta a busca se estiver ativa
              final currentQuery = ref.read(searchProvider).query;
              if (currentQuery.isNotEmpty) {
                ref.read(searchProvider.notifier).search(currentQuery);
              }
            }
          },
          onCopy: () async {
            await _clipboardService.copyAndNotify(context, password.password);
          },
        );
      },
    );
  }

  Widget _buildBody(HomeState state, ColorScheme colorScheme, ThemeData theme) {
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
                  ref.read(homeProvider.notifier).refresh();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    // Estado: vazio
    if (state.isEmpty) {
      final isFiltered = state.showFavoritesOnly;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isFiltered
                    ? Icons.star_outline_rounded
                    : Icons.lock_open_rounded,
                size: 64,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                isFiltered
                    ? 'Nenhuma senha favorita'
                    : 'Nenhuma senha cadastrada',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isFiltered
                    ? 'Marque senhas como favoritas para acessar rapidamente'
                    : 'Adicione sua primeira senha tocando no botao +',
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
      onRefresh: () => ref.read(homeProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.passwords.length,
        itemBuilder: (context, index) {
          final password = state.passwords[index];
          return PasswordListItem(
            password: password,
            onTap: () async {
              // Navega para detalhe e recarrega ao voltar
              final result = await context.push('/password/${password.id}');
              if (result == true) {
                ref.read(homeProvider.notifier).refresh();
              }
            },
            onCopy: () async {
              await _clipboardService.copyAndNotify(context, password.password);
            },
          );
        },
      ),
    );
  }
}
