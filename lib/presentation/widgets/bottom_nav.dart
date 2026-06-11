import 'package:flutter/material.dart';

/// Bottom Navigation Bar com 4 abas.
///
/// Segue UI/UX Guide: selecao visual clara, icones consistentes.
class BottomNav extends StatelessWidget {
  /// Index da aba selecionada.
  final int currentIndex;

  /// Callback ao mudar de aba.
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category_rounded),
          label: 'Categorias',
        ),
        NavigationDestination(
          icon: Icon(Icons.star_outline_rounded),
          selectedIcon: Icon(Icons.star_rounded),
          label: 'Favoritos',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings_rounded),
          label: 'Config',
        ),
      ],
    );
  }
}
