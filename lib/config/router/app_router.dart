import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/page_transitions.dart';
import 'package:lifeos/features/documents/presentation/screens/documents_placeholder_screen.dart';
import 'package:lifeos/features/finance/presentation/screens/finance_placeholder_screen.dart';
import 'package:lifeos/features/finance/presentation/screens/new_expense_screen.dart';
import 'package:lifeos/features/habits/presentation/screens/habit_detail_screen.dart';
import 'package:lifeos/features/habits/presentation/screens/habits_dashboard_screen.dart';
import 'package:lifeos/features/habits/presentation/screens/new_habit_screen.dart';
import 'package:lifeos/features/health/presentation/screens/health_placeholder_screen.dart';
import 'package:lifeos/features/home/presentation/screens/home_screen.dart';
import 'package:lifeos/features/home/presentation/screens/timeline_detail_screen.dart';
import 'package:lifeos/features/lists/presentation/screens/list_detail_screen.dart';
import 'package:lifeos/features/lists/presentation/screens/lists_screen.dart';
import 'package:lifeos/features/navigation/presentation/shell/app_shell.dart';
import 'package:lifeos/features/notes/presentation/screens/new_note_screen.dart';
import 'package:lifeos/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:lifeos/features/notes/presentation/screens/note_edit_screen.dart';
import 'package:lifeos/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:lifeos/features/notifications/presentation/screens/notifications_placeholder_screen.dart';
import 'package:lifeos/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/new_reminder_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/planner_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminder_detail_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_dashboard_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_list_screen.dart';
import 'package:lifeos/features/search/presentation/screens/search_screen.dart';
import 'package:lifeos/features/splash/presentation/screens/splash_screen.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/features/user_setup/presentation/screens/profile_placeholder_screen.dart';
import 'package:lifeos/features/user_setup/presentation/screens/user_setup_screen.dart';

/// Root navigator, distinct from each `StatefulShellBranch`'s own nested
/// navigator. Routes carrying `parentNavigatorKey: _rootNavigatorKey` push
/// onto this one instead, which escapes `AppShell`'s persistent
/// `FloatingBottomNav` chrome — see docs/architecture.md's Routing section.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
                routes: [
                  GoRoute(
                    path: RoutePaths.newNote,
                    name: RouteNames.newNote,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const NewNoteScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.newExpense,
                    name: RouteNames.newExpense,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const NewExpenseScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.search,
                    name: RouteNames.search,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const SearchScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.notifications,
                    name: RouteNames.notifications,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const NotificationsPlaceholderScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.profile,
                    name: RouteNames.profile,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const ProfilePlaceholderScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.timelineDetail,
                    name: RouteNames.timelineDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: TimelineDetailScreen(
                        stepId: state.pathParameters['stepId']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.notes,
                    name: RouteNames.notes,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const NotesListScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.noteEdit,
                    name: RouteNames.noteEdit,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: NoteEditScreen(
                        noteId: state.pathParameters['noteId']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.noteDetail,
                    name: RouteNames.noteDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: NoteDetailScreen(
                        noteId: state.pathParameters['noteId']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.lists,
                    name: RouteNames.lists,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const ListsScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.listDetail,
                    name: RouteNames.listDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: ListDetailScreen(
                        listId: state.pathParameters['listId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.reminders,
                name: RouteNames.reminders,
                builder: (context, state) => const RemindersDashboardScreen(),
                routes: [
                  // Static children declared before the dynamic
                  // `:reminderId` child below — go_router tries routes in
                  // declaration order, so `/reminders/all` and
                  // `/reminders/new` match these first instead of being
                  // captured as a `:reminderId` value of "all"/"new".
                  GoRoute(
                    path: RoutePaths.remindersAll,
                    name: RouteNames.remindersAll,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const RemindersListScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.newReminder,
                    name: RouteNames.newReminder,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: NewReminderScreen(
                        initialDate: state.extra is DateTime
                            ? state.extra! as DateTime
                            : null,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.planner,
                    name: RouteNames.planner,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const PlannerScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.habits,
                    name: RouteNames.habits,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const HabitsDashboardScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.newHabit,
                    name: RouteNames.newHabit,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const NewHabitScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.habitDetail,
                    name: RouteNames.habitDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: HabitDetailScreen(
                        habitId: state.pathParameters['habitId']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.reminderDetail,
                    name: RouteNames.reminderDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: ReminderDetailScreen(
                        reminderId: state.pathParameters['reminderId']!,
                      ),
                    ),
                  ),
                ],
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
