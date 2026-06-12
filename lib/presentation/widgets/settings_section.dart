import 'package:flutter/material.dart';

/// Widget reutilizavel para secao da tela de Configuracoes.
///
/// Exibe titulo de secao e conteudo (filho).
/// Segue /docs/design/UI_UX_GUIDE.md: hierarquia visual clara.
class SettingsSection extends StatelessWidget {
  /// Titulo da secao.
  final String title;

  /// Conteudo da secao.
  final Widget child;

  const SettingsSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
