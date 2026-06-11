import 'package:flutter/material.dart';

/// Botao de autenticacao biometrica.
///
/// Exibe icone de biometria (fingerprint ou face) com estados
/// de loading e erro. Segue UI_UX_GUIDE.md.
class BiometricButton extends StatelessWidget {
  /// Se esta autenticando.
  final bool isLoading;

  /// Se deve mostrar icone de face (true) ou fingerprint (false).
  final bool isFaceId;

  /// Callback ao pressionar.
  final VoidCallback? onPressed;

  const BiometricButton({
    super.key,
    this.isLoading = false,
    this.isFaceId = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF1F5F9), // Fundo leve do guia
          foregroundColor: const Color(0xFF1D4ED8), // Primaria do guia
          disabledBackgroundColor: const Color(0xFFF1F5F9),
          disabledForegroundColor: const Color(0xFF64748B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF1D4ED8),
                ),
              )
            : Icon(
                isFaceId ? Icons.face_outlined : Icons.fingerprint,
                size: 32,
              ),
      ),
    );
  }
}
