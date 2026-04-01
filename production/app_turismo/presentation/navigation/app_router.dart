import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/screens/business_promo_screen.dart';
import 'package:app_turismo/presentation/screens/discover_screen.dart';
import 'package:app_turismo/presentation/screens/generated_plan_page.dart';
import 'package:app_turismo/presentation/screens/home_screen.dart';
import 'package:app_turismo/presentation/screens/location_permission_screen.dart';
import 'package:app_turismo/presentation/screens/login_screen.dart';
import 'package:app_turismo/presentation/screens/nearby_screen.dart';
import 'package:app_turismo/presentation/screens/onboarding_screen.dart';
import 'package:app_turismo/presentation/screens/place_detail_screen.dart';
import 'package:app_turismo/presentation/screens/profile_screen.dart';
import 'package:app_turismo/presentation/screens/register_screen.dart';
import 'package:app_turismo/presentation/screens/safety_screen.dart';
import 'package:app_turismo/presentation/screens/saved_page.dart';
import 'package:app_turismo/presentation/screens/splash_screen.dart';
import 'package:app_turismo/presentation/screens/trip_planner_screen.dart';

const _kNavItems = [
  _NavItem(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded),
  _NavItem(
      label: 'Explorar',
      icon: Icons.map_outlined,
      activeIcon: Icons.map_rounded),
  _NavItem(
      label: 'Planear',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded),
  _NavItem(
      label: 'Cerca',
      icon: Icons.near_me_outlined,
      activeIcon: Icons.near_me_rounded),
  _NavItem(
      label: 'Perfil',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded),
];

/// Define la navegacion principal y secundaria de la app.
/// Mantiene estables las rutas usadas por la interfaz actual.
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConstants.routeSplash,
    routes: [
      GoRoute(
          path: AppConstants.routeSplash,
          builder: (_, __) => const SplashScreen()),
      GoRoute(
          path: AppConstants.routeOnboarding,
          builder: (_, __) => const OnboardingScreen()),
      GoRoute(
          path: AppConstants.routeLocationPermission,
          builder: (_, __) => const LocationPermissionScreen()),
      GoRoute(
          path: AppConstants.routeLogin,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const LoginScreen()),
      GoRoute(
          path: AppConstants.routeRegister,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: AppConstants.routePlaceDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? '';
          return PlaceDetailScreen(placeId: id);
        },
      ),
      GoRoute(
        path: AppConstants.routeGeneratedPlan,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const GeneratedPlanPage(),
      ),
      GoRoute(
          path: AppConstants.routeSafety,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const SafetyScreen()),
      GoRoute(
          path: AppConstants.routeSaved,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const SavedPage()),
      GoRoute(
          path: AppConstants.routeBusinessPromo,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const BusinessPromoScreen()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) =>
            _ShellScaffold(state: state, child: child),
        routes: [
          GoRoute(
              path: AppConstants.routeHome,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen())),
          GoRoute(
              path: AppConstants.routeDiscover,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: DiscoverScreen())),
          GoRoute(
              path: AppConstants.routePlanner,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: TripPlannerScreen())),
          GoRoute(
              path: AppConstants.routeNearby,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: NearbyScreen())),
          GoRoute(
              path: AppConstants.routeProfile,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileScreen())),
        ],
      ),
    ],
  );
}

class _ShellScaffold extends StatelessWidget {
  final GoRouterState state;
  final Widget child;

  const _ShellScaffold({required this.state, required this.child});

  int _getIndex(GoRouterState state) {
    final path = state.uri.path;
    if (path.startsWith(AppConstants.routeDiscover)) return 1;
    if (path.startsWith(AppConstants.routePlanner)) return 2;
    if (path.startsWith(AppConstants.routeNearby)) return 3;
    if (path.startsWith(AppConstants.routeProfile)) return 4;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    final routes = [
      AppConstants.routeHome,
      AppConstants.routeDiscover,
      AppConstants.routePlanner,
      AppConstants.routeNearby,
      AppConstants.routeProfile,
    ];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex(state);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _kNavItems.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                final isActive = i == currentIndex;
                return _NavButton(
                    item: item,
                    isActive: isActive,
                    onTap: () => _onTabTapped(context, i));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton(
      {required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: AppConstants.animFast,
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey(isActive),
                color: isActive ? AppColors.primary : AppColors.textTertiary,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const _NavItem(
      {required this.label, required this.icon, required this.activeIcon});
}
