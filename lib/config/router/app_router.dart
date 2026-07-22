import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/page_transitions.dart';
import 'package:lifeos/features/calendar/presentation/screens/calendar_dashboard_screen.dart';
import 'package:lifeos/features/calendar/presentation/screens/event_detail_screen.dart';
import 'package:lifeos/features/calendar/presentation/screens/new_event_screen.dart';
import 'package:lifeos/features/activity/presentation/screens/activity_screen.dart';
import 'package:lifeos/features/documents/presentation/screens/documents_placeholder_screen.dart';
import 'package:lifeos/features/finance/presentation/screens/finance_placeholder_screen.dart';
import 'package:lifeos/features/finance/presentation/screens/new_expense_screen.dart';
import 'package:lifeos/features/focus/presentation/screens/focus_completion_screen.dart';
import 'package:lifeos/features/focus/presentation/screens/focus_screen.dart';
import 'package:lifeos/features/focus/presentation/screens/focus_session_detail_screen.dart';
import 'package:lifeos/features/habits/presentation/screens/habit_detail_screen.dart';
import 'package:lifeos/features/habits/presentation/screens/habits_dashboard_screen.dart';
import 'package:lifeos/features/habits/presentation/screens/new_habit_screen.dart';
import 'package:lifeos/features/health/presentation/providers/health_workspace_section_provider.dart';
import 'package:lifeos/features/health/presentation/screens/health_overview_screen.dart';
import 'package:lifeos/features/health/presentation/widgets/health_workspace_scaffold.dart';
import 'package:lifeos/features/home/presentation/screens/home_screen.dart';
import 'package:lifeos/features/hydration/presentation/screens/hydration_screen.dart';
import 'package:lifeos/features/home/presentation/screens/timeline_detail_screen.dart';
import 'package:lifeos/features/lists/presentation/screens/list_detail_screen.dart';
import 'package:lifeos/features/lists/presentation/screens/lists_screen.dart';
import 'package:lifeos/features/medications/presentation/screens/medication_detail_screen.dart';
import 'package:lifeos/features/medications/presentation/screens/medications_dashboard_screen.dart';
import 'package:lifeos/features/medications/presentation/screens/new_medication_screen.dart';
import 'package:lifeos/features/mood/presentation/screens/log_mood_screen.dart';
import 'package:lifeos/features/mood/presentation/screens/mood_dashboard_screen.dart';
import 'package:lifeos/features/navigation/presentation/shell/app_shell.dart';
import 'package:lifeos/features/notes/presentation/screens/new_note_screen.dart';
import 'package:lifeos/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:lifeos/features/notes/presentation/screens/note_edit_screen.dart';
import 'package:lifeos/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:lifeos/features/notifications/presentation/screens/notifications_placeholder_screen.dart';
import 'package:lifeos/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lifeos/features/reminders/presentation/providers/planning_workspace_section_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/new_reminder_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminder_detail_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_dashboard_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_list_screen.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planning_workspace_scaffold.dart';
import 'package:lifeos/features/search/presentation/screens/search_screen.dart';
import 'package:lifeos/features/sleep/presentation/screens/sleep_screen.dart';
import 'package:lifeos/features/splash/presentation/screens/splash_screen.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/features/user_setup/presentation/screens/profile_placeholder_screen.dart';
import 'package:lifeos/features/user_setup/presentation/screens/user_setup_screen.dart';
import 'package:lifeos/features/weight/presentation/screens/weight_screen.dart';

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
                    path: RoutePaths.focus,
                    name: RouteNames.focus,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const FocusScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.focusCompletion,
                    name: RouteNames.focusCompletion,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: FocusCompletionScreen(
                        sessionId: state.uri.queryParameters['sessionId']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.focusSessionDetail,
                    name: RouteNames.focusSessionDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: FocusSessionDetailScreen(
                        sessionId: state.pathParameters['sessionId']!,
                      ),
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
                builder: (context, state) => const PlanningWorkspaceScaffold(
                  remindersBody: RemindersDashboardScreen(),
                  habitsBody: HabitsDashboardScreen(),
                  calendarBody: CalendarDashboardScreen(),
                ),
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
                    // No pageBuilder: selecting the Planner tab is local
                    // workspace state now (see planningWorkspaceScaffold.dart
                    // + planningWorkspaceSectionProvider), not a pushed
                    // page — this route exists only so
                    // `/reminders/planner` deep-links and any
                    // `context.pushNamed(RouteNames.planner)` call sites
                    // still resolve, by selecting the tab then redirecting
                    // back to the workspace root instead of 404ing.
                    //
                    // The provider write is deferred via `Future.microtask`
                    // because `redirect` runs during route resolution, which
                    // is itself part of the widget tree's build phase —
                    // writing to a provider synchronously here throws
                    // "Tried to modify a provider while the widget tree was
                    // building."
                    redirect: (context, state) {
                      Future.microtask(
                        () => ref
                            .read(planningWorkspaceSectionProvider.notifier)
                            .select(PlanningWorkspaceSection.planner),
                      );
                      return RoutePaths.reminders;
                    },
                  ),
                  GoRoute(
                    path: RoutePaths.habits,
                    name: RouteNames.habits,
                    // See the `planner` route above for why this is
                    // redirect-only and defers its provider write.
                    redirect: (context, state) {
                      Future.microtask(
                        () => ref
                            .read(planningWorkspaceSectionProvider.notifier)
                            .select(PlanningWorkspaceSection.habits),
                      );
                      return RoutePaths.reminders;
                    },
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
                    path: RoutePaths.calendar,
                    name: RouteNames.calendar,
                    // See the `planner` route above for why this is
                    // redirect-only and defers its provider write.
                    redirect: (context, state) {
                      Future.microtask(
                        () => ref
                            .read(planningWorkspaceSectionProvider.notifier)
                            .select(PlanningWorkspaceSection.calendar),
                      );
                      return RoutePaths.reminders;
                    },
                  ),
                  GoRoute(
                    path: RoutePaths.newEvent,
                    name: RouteNames.newEvent,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: NewEventScreen(
                        initialDate: state.extra is DateTime
                            ? state.extra! as DateTime
                            : null,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.eventDetail,
                    name: RouteNames.eventDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: EventDetailScreen(
                        eventId: state.pathParameters['eventId']!,
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
                builder: (context, state) => const HealthWorkspaceScaffold(
                  overviewBody: HealthOverviewScreen(),
                  moodBody: MoodDashboardScreen(),
                  medicationsBody: MedicationsDashboardScreen(),
                ),
                routes: [
                  // Static children declared before the dynamic
                  // `:moodId`/`:medicationId` children below — same
                  // static-before-dynamic reason as Habits/Calendar under
                  // `/reminders`.
                  GoRoute(
                    path: RoutePaths.mood,
                    name: RouteNames.mood,
                    // No pageBuilder: selecting the Mood tab is local
                    // workspace state (see health_workspace_scaffold.dart +
                    // healthWorkspaceSectionProvider), not a pushed page —
                    // mirrors the `habits`/`calendar` tab routes under
                    // `/reminders`.
                    redirect: (context, state) {
                      Future.microtask(
                        () => ref
                            .read(healthWorkspaceSectionProvider.notifier)
                            .select(HealthWorkspaceSection.mood),
                      );
                      return RoutePaths.health;
                    },
                  ),
                  GoRoute(
                    path: RoutePaths.logMood,
                    name: RouteNames.logMood,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const LogMoodScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.medications,
                    name: RouteNames.medications,
                    // See the `mood` route above for why this is
                    // redirect-only and defers its provider write.
                    redirect: (context, state) {
                      Future.microtask(
                        () => ref
                            .read(healthWorkspaceSectionProvider.notifier)
                            .select(HealthWorkspaceSection.medications),
                      );
                      return RoutePaths.health;
                    },
                  ),
                  GoRoute(
                    path: RoutePaths.newMedication,
                    name: RouteNames.newMedication,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const NewMedicationScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.medicationDetail,
                    name: RouteNames.medicationDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: MedicationDetailScreen(
                        medicationId: state.pathParameters['medicationId']!,
                      ),
                    ),
                  ),
                  // Hydration/Sleep/Weight/Activity — pushed screens reached
                  // only from Health Overview's cards, not their own nav-bar
                  // tab or redirect route (see `HealthWorkspaceSection`'s
                  // doc comment on why the nav bar stops at three items).
                  GoRoute(
                    path: RoutePaths.hydration,
                    name: RouteNames.hydration,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const HydrationScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.sleep,
                    name: RouteNames.sleep,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const SleepScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.weight,
                    name: RouteNames.weight,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const WeightScreen(),
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.activity,
                    name: RouteNames.activity,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => buildFadeThroughPage(
                      key: state.pageKey,
                      child: const ActivityScreen(),
                    ),
                  ),
                ],
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
