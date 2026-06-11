import 'package:flutter/material.dart';

/// Toggle de biometria para a tela de Configuracoes.
///
/// Switch list tile com icone de biometria e subtítulo explicativo.
/// Segue UI_UX_GUIDE.md.
class BiometricToggle extends StatelessWidget {
  /// Se o toggle esta ativado.
  final bool value;

  /// Callback ao alterar valor.
  final ValueChanged<bool>? onChanged;

  /// Se biometria esta disponivel no dispositivo.
  final bool isAvailable;

  const BiometricToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.isAvailable = false,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(
        Icons.fingerprint,
        color: Color(0xFF1D4ED8), // Primaria do guia
      ),
      title: const Text(
        'Usar biometria',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF0F172A), // Texto principal do guia
        ),
      ),
      subtitle: Text(
        isAvailable
            ? 'Desbloqueie com impressão digital ou reconhecimento facial'
            : 'Biometria não disponível neste dispositivo',
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF64748B), // Texto discreto do guia
        ),
      ),
      value: value,
      onChanged: isAvailable ? onChanged : null,
      activeThumbColor: const Color(0xFF1D4ED8),
    );
  }
}
