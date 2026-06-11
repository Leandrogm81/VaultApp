import 'package:flutter/material.dart';

import '../../domain/entities/password.dart';

/// Widget reutilizavel para exibir um item na lista de senhas.
///
/// Exibe: icone, titulo, username, botao copiar, indicador favorito.
/// Segue UI/UX Guide: paleta, tipografia, espacamento.
class PasswordListItem extends StatelessWidget {
  /// A senha a ser exibida.
  final Password password;

  /// Callback ao tocar no item (navegar para detalhe).
  final VoidCallback? onTap;

  /// Callback ao pressionar o botao copiar.
  final VoidCallback? onCopy;

  const PasswordListItem({
    super.key,
    required this.password,
    this.onTap,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icone do servico
              _buildServiceIcon(colorScheme),
              const SizedBox(width: 12),

              // Titulo e username
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            password.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (password.favorite)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: colorScheme.tertiary,
                            ),
                          ),
                      ],
                    ),
                    if (password.username.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          password.username,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              // Botao copiar
              IconButton(
                onPressed: onCopy,
                icon: Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Copiar senha',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constroi o icone do servico baseado na URL ou titulo.
  Widget _buildServiceIcon(ColorScheme colorScheme) {
    final iconData = _getIconForService(password.url ?? password.title);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        size: 20,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Retorna um icone adequado para o servico.
  IconData _getIconForService(String identifier) {
    final lower = identifier.toLowerCase();

    if (lower.contains('google') || lower.contains('gmail')) {
      return Icons.mail_rounded;
    }
    if (lower.contains('github')) {
      return Icons.code_rounded;
    }
    if (lower.contains('bank') || lower.contains('banco') ||
        lower.contains('finance') || lower.contains('nubank') ||
        lower.contains('itau') || lower.contains('bradesco')) {
      return Icons.account_balance_rounded;
    }
    if (lower.contains('social') || lower.contains('facebook') ||
        lower.contains('instagram') || lower.contains('twitter') ||
        lower.contains('linkedin')) {
      return Icons.people_rounded;
    }
    if (lower.contains('shop') || lower.contains('compra') ||
        lower.contains('amazon') || lower.contains('mercado')) {
      return Icons.shopping_cart_rounded;
    }
    if (lower.contains('work') || lower.contains('trabalho') ||
        lower.contains('slack') || lower.contains('teams')) {
      return Icons.work_rounded;
    }

    return Icons.lock_rounded;
  }
}
