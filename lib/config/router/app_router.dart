import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/page_transitions.dart';
import 'package:lifeos/features/documents/presentation/screens/documents_placeholder_screen.dart';
import 'package:lifeos/features/finance/presentation/screens/finance_placeholder_screen.dart';
import 'package:lifeos/features/health/presentation/screens/health_placeholder_screen.dart';
import 'package:lifeos/features/home/presentation/screens/home_screen.dart';
import 'package:lifeos/features/navigation/presentation/shell/app_shell.dart';
import 'package:lifeos/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_placeholder_screen.dart';
import 'package:lifeos/features/splash/presentation/screens/splash_screen.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/features/user_setup/presentation/screens/user_setup_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      final onboardingComplete = ref.read(onboardingCompleteProvider);
      final location = state.matchedLocation;

      final isAuthFlow =
          location == RoutePaths.onboarding ||
          location == RoutePaths.userSetup ||
          location == RoutePaths.splash;

      if (!onboardingComplete && !isAuthFlow) {
        return RoutePaths.onboarding;
      }
      if (onboardingComplete &&
          (location == RoutePaths.onboarding ||
              location == RoutePaths.userSetup)) {
        return RoutePaths.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) => buildFadeThroughPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => buildFadeThroughPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.userSetup,
        name: RouteNames.userSetup,
        pageBuilder: (context, state) => buildFadeThroughPage(
          key: state.pageKey,
          child: const UserSetupScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                // Explicit fade-through page transition: StatefulShellRoute
                // itself has no pageBuilder, so without this the
                // /user-setup -> /home hop (and any direct navigation to
                // this branch) would fall back to the platform default
                // transition instead of the same FadeThroughTransition used
                // by splash/onboarding/user-setup.
                pageBuilder: (context, state) => buildFadeThroughPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.reminders,
                name: RouteNames.reminders,
                builder: (context, state) => const RemindersPlaceholderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.health,
                name: RouteNames.health,
                builder: (context, state) => const HealthPlaceholderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.finance,
                name: RouteNames.finance,
                builder: (context, state) => const FinancePlaceholderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.documents,
                name: RouteNames.documents,
                builder: (context, state) => const DocumentsPlaceholderScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
