import 'package:flutter/material.dart';

/// Widget de selecao de tema.
///
/// Exibe 3 opcoes: Claro, Escuro, Sistema.
/// Segue /docs/design/UI_UX_GUIDE.md: clareza, hierarquia, sem aparencia de IA.
class ThemeSelector extends StatelessWidget {
  /// Preferencia de tema atual ("light", "dark", "system").
  final String currentPreference;

  /// Callback ao mudar a preferencia.
  final ValueChanged<String> onChanged;

  const ThemeSelector({
    super.key,
    required this.currentPreference,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ThemeOption(
          label: 'Claro',
          icon: Icons.light_mode_outlined,
          selectedIcon: Icons.light_mode_rounded,
          preference: 'light',
          isSelected: currentPreference == 'light',
          onTap: () => onChanged('light'),
        ),
        _ThemeOption(
          label: 'Escuro',
          icon: Icons.dark_mode_outlined,
          selectedIcon: Icons.dark_mode_rounded,
          preference: 'dark',
          isSelected: currentPreference == 'dark',
          onTap: () => onChanged('dark'),
        ),
        _ThemeOption(
          label: 'Sistema',
          icon: Icons.phone_android_outlined,
          selectedIcon: Icons.phone_android_rounded,
          preference: 'system',
          isSelected: currentPreference == 'system',
          onTap: () => onChanged('system'),
          subtitle: 'Segue a configuracao do dispositivo',
        ),
      ],
    );
  }
}

/// Opcao individual de tema.
class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String preference;
  final bool isSelected;
  final VoidCallback onTap;
  final String? subtitle;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.preference,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isSelected ? selectedIcon : icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: isSelected
          ? Icon(
              Icons.check_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      dense: true,
    );
  }
}
