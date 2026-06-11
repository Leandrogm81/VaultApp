import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/home_viewmodel.dart';
import '../widgets/password_list_item.dart';
import '../../core/services/clipboard_service.dart';

/// Tela principal do VaultApp — lista de senhas.
///
/// Exibe: AppBar, lista de senhas (ListView.builder), FAB "+",
/// estados: loading, vazio, erro.
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VaultApp',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              // Placeholder para pesquisa (Sprint 7)
            },
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Pesquisar',
          ),
        ],
      ),
      body: _buildBody(homeState, colorScheme, theme),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/password/new');
        },
        tooltip: 'Adicionar senha',
        child: const Icon(Icons.add_rounded),
      ),
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_open_rounded,
                size: 64,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhuma senha cadastrada',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Adicione sua primeira senha tocando no botao +',
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
