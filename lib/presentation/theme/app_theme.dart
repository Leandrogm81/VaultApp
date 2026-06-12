import 'package:flutter/material.dart';

/// Temas do VaultApp (claro e escuro).
///
/// Segue /docs/design/UI_UX_GUIDE.md para cores, tipografia e espacamento.
/// Paleta sobria e profissional, sem aparencia generica de IA.
class AppTheme {
  AppTheme._();

  /// Tema claro — cores seguindo UI_UX_GUIDE.md.
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1D4ED8),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFDBEAFE),
      onPrimaryContainer: Color(0xFF1E3A5F),
      secondary: Color(0xFF475569),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFF1F5F9),
      onSecondaryContainer: Color(0xFF334155),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF0F172A),
      surfaceContainerLowest: Color(0xFFF8FAFC),
      surfaceContainerLow: Color(0xFFF1F5F9),
      surfaceContainer: Color(0xFFE2E8F0),
      onSurfaceVariant: Color(0xFF64748B),
      outline: Color(0xFFE2E8F0),
      outlineVariant: Color(0xFFCBD5E1),
      error: Color(0xFFB91C1C),
      onError: Colors.white,
      errorContainer: Color(0xFFFEF2F2),
      onErrorContainer: Color(0xFF991B1B),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFFF8FAFC),
        foregroundColor: Color(0xFF0F172A),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2E8F0),
        thickness: 1,
        space: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDBEAFE),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D4ED8),
            );
          }
          return const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          );
        }),
      ),
    );
  }

  /// Tema escuro — cores seguindo UI_UX_GUIDE.md adaptado para dark mode.
  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF60A5FA),
      onPrimary: Color(0xFF1E3A5F),
      primaryContainer: Color(0xFF1E40AF),
      onPrimaryContainer: Color(0xFFDBEAFE),
      secondary: Color(0xFF94A3B8),
      onSecondary: Color(0xFF1E293B),
      secondaryContainer: Color(0xFF334155),
      onSecondaryContainer: Color(0xFFF1F5F9),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF1F5F9),
      surfaceContainerLowest: Color(0xFF0F172A),
      surfaceContainerLow: Color(0xFF1E293B),
      surfaceContainer: Color(0xFF334155),
      onSurfaceVariant: Color(0xFF94A3B8),
      outline: Color(0xFF475569),
      outlineVariant: Color(0xFF334155),
      error: Color(0xFFFCA5A5),
      onError: Color(0xFF7F1D1D),
      errorContainer: Color(0xFF991B1B),
      onErrorContainer: Color(0xFFFEE2E2),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Color(0xFFF1F5F9),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155),
        thickness: 1,
        space: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: const Color(0xFF1E40AF),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF60A5FA),
            );
          }
          return const TextStyle(
            fontSize: 12,
            color: Color(0xFF94A3B8),
          );
        }),
      ),
    );
  }
}
