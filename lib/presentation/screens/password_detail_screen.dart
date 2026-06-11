import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../viewmodels/password_detail_viewmodel.dart';
import '../widgets/confirm_dialog.dart';
import '../../core/services/clipboard_service.dart';
import '../../domain/entities/password.dart';

/// Tela de detalhe da senha — exibe todos os campos e acoes.
///
/// Segue UI/UX Guide: hierarquia visual, labels, botoes de acao.
class PasswordDetailScreen extends ConsumerStatefulWidget {
  /// ID da senha a ser exibida.
  final String passwordId;

  const PasswordDetailScreen({
    super.key,
    required this.passwordId,
  });

  @override
  ConsumerState<PasswordDetailScreen> createState() =>
      _PasswordDetailScreenState();
}

class _PasswordDetailScreenState extends ConsumerState<PasswordDetailScreen> {
  bool _obscurePassword = true;
  final _clipboardService = ClipboardService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final detailState = ref.watch(passwordDetailProvider(widget.passwordId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          detailState.password?.title ?? 'Detalhe',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          if (detailState.password != null) ...[
            IconButton(
              onPressed: () async {
                final result = await context.push(
                  '/password/${widget.passwordId}/edit',
                );
                if (result == true) {
                  ref
                      .read(passwordDetailProvider(widget.passwordId).notifier)
                      .loadPassword();
                }
              },
              icon: const Icon(Icons.edit_rounded),
              tooltip: 'Editar',
            ),
            IconButton(
              onPressed: () => _confirmDelete(context, colorScheme),
              icon: Icon(
                Icons.delete_outline_rounded,
                color: colorScheme.error,
              ),
              tooltip: 'Excluir',
            ),
          ],
        ],
      ),
      body: _buildBody(detailState, colorScheme, theme),
    );
  }

  Widget _buildBody(
      PasswordDetailState state, ColorScheme colorScheme, ThemeData theme) {
    // Estado: loading
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
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
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {
                  ref
                      .read(passwordDetailProvider(widget.passwordId).notifier)
                      .loadPassword();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    // Estado: dados carregados
    final password = state.password;
    if (password == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Secao de campos
          _buildFieldSection(context, theme, colorScheme, password),

          const SizedBox(height: 24),

          // Botoes de acao
          _buildActionButtons(context, theme, colorScheme, password),
        ],
      ),
    );
  }

  /// Constroi a secao de campos da senha.
  Widget _buildFieldSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Password password,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titulo
            _buildDetailRow(
              theme,
              colorScheme,
              label: 'Titulo',
              value: password.title,
              icon: Icons.title_rounded,
            ),

            // URL (clicavel)
            if (password.url != null && password.url!.isNotEmpty)
              _buildDetailRow(
                theme,
                colorScheme,
                label: 'URL',
                value: password.url!,
                icon: Icons.link_rounded,
                onTap: () => _launchUrl(password.url!),
              ),

            // Username
            if (password.username.isNotEmpty)
              _buildDetailRow(
                theme,
                colorScheme,
                label: 'Usuario',
                value: password.username,
                icon: Icons.person_rounded,
                onCopy: () => _copyToClipboard(context, password.username),
              ),

            // Senha (com toggle)
            _buildDetailRow(
              theme,
              colorScheme,
              label: 'Senha',
              value: _obscurePassword ? '••••••••' : password.password,
              icon: Icons.lock_rounded,
              obscure: _obscurePassword,
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 20,
                ),
                tooltip: _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                visualDensity: VisualDensity.compact,
              ),
              onCopy: () => _copyToClipboard(context, password.password),
            ),

            // Notas
            if (password.notes != null && password.notes!.isNotEmpty)
              _buildDetailRow(
                theme,
                colorScheme,
                label: 'Notas',
                value: password.notes!,
                icon: Icons.notes_rounded,
              ),
          ],
        ),
      ),
    );
  }

  /// Constroi uma linha de detalhe.
  Widget _buildDetailRow(
    ThemeData theme,
    ColorScheme colorScheme, {
    required String label,
    required String value,
    required IconData icon,
    bool obscure = false,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onCopy,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: onTap != null
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      decoration:
                          onTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ),
              ),
              if (trailing != null) trailing,
              if (onCopy != null)
                IconButton(
                  onPressed: onCopy,
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Copiar',
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          Divider(
            color: colorScheme.outlineVariant,
            height: 16,
          ),
        ],
      ),
    );
  }

  /// Constroi os botoes de acao.
  Widget _buildActionButtons(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Password password,
  ) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _copyToClipboard(context, password.username),
            icon: const Icon(Icons.person_rounded, size: 18),
            label: const Text('Copiar usuario'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _copyToClipboard(context, password.password),
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('Copiar senha'),
          ),
        ),
        if (password.url != null && password.url!.isNotEmpty) ...[
          const SizedBox(width: 12),
          FilledButton.tonalIcon(
            onPressed: () => _launchUrl(password.url!),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text('Abrir'),
          ),
        ],
      ],
    );
  }

  /// Copia texto para o clipboard e exibe feedback.
  void _copyToClipboard(BuildContext context, String text) {
    _clipboardService.copyAndNotify(context, text);
  }

  /// Abre URL no browser externo.
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Confirma exclusao da senha.
  void _confirmDelete(BuildContext context, ColorScheme colorScheme) {
    final password = ref.read(passwordDetailProvider(widget.passwordId)).password;
    if (password == null) return;

    showConfirmDialog(
      context: context,
      title: 'Confirmar exclusao',
      message: 'Tem certeza que deseja excluir "${password.title}"?',
      confirmLabel: 'Excluir',
    ).then((confirmed) async {
      if (confirmed) {
        final deleted = await ref
            .read(passwordDetailProvider(widget.passwordId).notifier)
            .deletePassword();
        if (deleted && context.mounted) {
          context.pop(true); // retorna true para recarregar
        }
      }
    });
  }
}
