import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/calendar/presentation/screens/calendar_dashboard_screen.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/features/habits/presentation/screens/habit_detail_screen.dart';
import 'package:lifeos/features/habits/presentation/screens/habits_dashboard_screen.dart';
import 'package:lifeos/features/habits/presentation/screens/new_habit_screen.dart';
import 'package:lifeos/features/reminders/presentation/providers/planning_workspace_section_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/planner_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_dashboard_screen.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planning_workspace_scaffold.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:lifeos/theme/theme_providers.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSecureStorage extends FlutterSecureStorage {
  const _FakeSecureStorage(this._store);

  final Map<String, String> _store;

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _store[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {}
}

class _FixedWorkspaceNotifier extends CurrentWorkspaceNotifier {
  _FixedWorkspaceNotifier(this._fixed);

  final String _fixed;

  @override
  String build() => _fixed;
}

Finder findBySemanticsLabel(String label) => find.byWidgetPredicate(
  (widget) => widget is Semantics && widget.properties.label == label,
);

/// Router integration test focused specifically on the Habits routes added
/// in Phase 6, mirroring `app_router_test.dart`'s "Planner routing" group
/// shape/harness but scoped to just the Habits sub-tree — verifies static-
/// vs-dynamic ordering, workspace-nav wiring, and Planner<->Habits detail
/// navigation, without duplicating the full app router's every branch.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);

    late ProviderContainer container;
    final router = GoRouter(
      initialLocation: RoutePaths.reminders,
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
            GoRoute(
              path: RoutePaths.planner,
              name: RouteNames.planner,
              redirect: (context, state) {
                final scopedContainer = ProviderScope.containerOf(context);
                Future.microtask(
                  () => scopedContainer
                      .read(planningWorkspaceSectionProvider.notifier)
                      .select(PlanningWorkspaceSection.planner),
                );
                return RoutePaths.reminders;
              },
            ),
            GoRoute(
              path: RoutePaths.habits,
              name: RouteNames.habits,
              redirect: (context, state) {
                final scopedContainer = ProviderScope.containerOf(context);
                Future.microtask(
                  () => scopedContainer
                      .read(planningWorkspaceSectionProvider.notifier)
                      .select(PlanningWorkspaceSection.habits),
                );
                return RoutePaths.reminders;
              },
            ),
            GoRoute(
              path: RoutePaths.newHabit,
              name: RouteNames.newHabit,
              builder: (context, state) => const NewHabitScreen(),
            ),
            GoRoute(
              path: RoutePaths.habitDetail,
              name: RouteNames.habitDetail,
              builder: (context, state) =>
                  HabitDetailScreen(habitId: state.pathParameters['habitId']!),
            ),
          ],
        ),
        GoRoute(
          path: '/search',
          name: RouteNames.search,
          builder: (context, state) => const Scaffold(body: Text('Search')),
        ),
        GoRoute(
          path: '/notifications',
          name: RouteNames.notifications,
          builder: (context, state) =>
              const Scaffold(body: Text('Notifications')),
        ),
        GoRoute(
          path: '/profile',
          name: RouteNames.profile,
          builder: (context, state) => const Scaffold(body: Text('Profile')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider.overrideWithValue(
            PreferencesService(prefs),
          ),
          secureStorageServiceProvider.overrideWithValue(
            SecureStorageService(const _FakeSecureStorage({})),
          ),
          databaseProvider.overrideWithValue(db),
          currentWorkspaceProvider.overrideWith(
            () => _FixedWorkspaceNotifier(WorkspaceIds.reminders),
          ),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  void tapWorkspaceNavItem(WidgetTester tester, String label) {
    final semantics = findBySemanticsLabel(label);
    final gestureDetector = find
        .ancestor(of: semantics, matching: find.byType(GestureDetector))
        .first;
    (tester.widget(gestureDetector) as GestureDetector).onTap!();
  }

  /// All four workspace tabs stay mounted (keep-alive) inside
  /// `PlanningWorkspaceScaffold`'s `Visibility(maintainState: true)`
  /// wrappers, so `find.byType` alone always finds one — this asserts it's
  /// also the currently selected tab, i.e. its nearest `Visibility`
  /// ancestor has `visible: true`.
  bool isSelectedTab(Type type) {
    final element = find.byType(type).evaluate().single;
    final visibility = element.findAncestorWidgetOfExactType<Visibility>();
    return visibility?.visible ?? true;
  }

  testWidgets('/reminders/habits is a static route reached from the '
      'Reminders workspace nav', (tester) async {
    await pumpApp(tester);

    tapWorkspaceNavItem(tester, 'Habits');
    await tester.pumpAndSettle();

    expect(isSelectedTab(HabitsDashboardScreen), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Habits workspace nav Reminders tile returns to the Reminders '
      'dashboard', (tester) async {
    await pumpApp(tester);

    tapWorkspaceNavItem(tester, 'Habits');
    await tester.pumpAndSettle();
    expect(isSelectedTab(HabitsDashboardScreen), isTrue);

    tapWorkspaceNavItem(tester, 'Reminders');
    await tester.pumpAndSettle();

    expect(isSelectedTab(RemindersDashboardScreen), isTrue);
  });

  testWidgets(
    'goNamed(newHabit) resolves to the static NewHabitScreen route, not '
    'HabitDetailScreen with a habitId of "new" — static-before-dynamic '
    'route declaration order (see route_paths.dart\'s doc comment)',
    (tester) async {
      await pumpApp(tester);

      GoRouter.of(
        tester.element(find.byType(RemindersDashboardScreen)),
      ).goNamed(RouteNames.newHabit);
      await tester.pumpAndSettle();

      expect(find.byType(NewHabitScreen), findsOneWidget);
      expect(find.byType(HabitDetailScreen), findsNothing);
    },
  );

  testWidgets('Habits -> open a habit detail -> back returns to Habits '
      'unchanged', (tester) async {
    final container = await pumpApp(tester);
    await container
        .read(habitsRepositoryProvider)
        .create(
          id: 'h1',
          title: 'Read',
          schedule: const HabitSchedule.daily(),
          icon: 'book',
        );

    tapWorkspaceNavItem(tester, 'Habits');
    await tester.pumpAndSettle();

    final controller = tester
        .widget<CustomScrollView>(find.byType(CustomScrollView))
        .controller!;
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    await tester.tap(find.text('Read').first, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(HabitDetailScreen), findsOneWidget);

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pop();
    await tester.pumpAndSettle();

    expect(isSelectedTab(HabitsDashboardScreen), isTrue);
  });

  testWidgets('Habits Add Habit -> back returns to Habits', (tester) async {
    await pumpApp(tester);

    tapWorkspaceNavItem(tester, 'Habits');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Habit'));
    await tester.pumpAndSettle();

    expect(find.byType(NewHabitScreen), findsOneWidget);

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pop();
    await tester.pumpAndSettle();

    expect(isSelectedTab(HabitsDashboardScreen), isTrue);
  });

  testWidgets(
    'Planner shows a habit occurrence today and tapping it opens HabitDetailScreen',
    (tester) async {
      final container = await pumpApp(tester);
      await container
          .read(habitsRepositoryProvider)
          .create(
            id: 'h1',
            title: 'Stretch',
            schedule: const HabitSchedule.daily(),
            icon: 'star',
          );

      tapWorkspaceNavItem(tester, 'Planner');
      await tester.pumpAndSettle();

      expect(isSelectedTab(PlannerScreen), isTrue);
      expect(find.text('Stretch'), findsOneWidget);

      await tester.tap(find.text('Stretch'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(HabitDetailScreen), findsOneWidget);
    },
  );
}
