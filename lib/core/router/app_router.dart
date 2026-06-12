import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/password_detail_screen.dart';
import '../../presentation/screens/password_form_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/widgets/bottom_nav.dart';

/// Router principal do VaultApp usando go_router.
///
/// Rotas: /home, /password/:id, /password/new, /password/:id/edit
class AppRouter {
  /// Chave de navegacao global.
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  /// Rotas do app.
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      // Shell route com bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNav(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          // Placeholder para Categorias (Sprint 6)
          GoRoute(
            path: '/categories',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderScreen(title: 'Categorias'),
            ),
          ),
          // Placeholder para Favoritos (Sprint 6)
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderScreen(title: 'Favoritos'),
            ),
          ),
          // Config (Sprint 9)
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      // Detalhe da senha (fora do shell — sem bottom nav)
      GoRoute(
        path: '/password/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PasswordDetailScreen(passwordId: id);
        },
      ),
      // Formulario de criacao
      GoRoute(
        path: '/password/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PasswordFormScreen(),
      ),
      // Formulario de edicao
      GoRoute(
        path: '/password/:id/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PasswordFormScreen(passwordId: id);
        },
      ),
    ],
  );
}

/// Scaffold com bottom navigation.
class ScaffoldWithNav extends StatefulWidget {
  /// Widget filho (conteudo da rota).
  final Widget child;

  const ScaffoldWithNav({super.key, required this.child});

  @override
  State<ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

class _ScaffoldWithNavState extends State<ScaffoldWithNav> {
  int _currentIndex = 0;

  /// Mapeia rotas para indices da bottom nav.
  int _getNavIndex(String location) {
    if (location.startsWith('/categories')) return 1;
    if (location.startsWith('/favorites')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0; // /home e padrao
  }

  /// Mapeia indices da bottom nav para rotas.
  String _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return '/home';
      case 1:
        return '/categories';
      case 2:
        return '/favorites';
      case 3:
        return '/settings';
      default:
        return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final newIndex = _getNavIndex(location);

    // Atualiza indice se mudou
    if (newIndex != _currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _currentIndex = newIndex;
        });
      });
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          context.go(_getRouteForIndex(index));
        },
      ),
    );
  }
}

/// Tela placeholder para abas ainda nao implementadas.
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Em breve',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
