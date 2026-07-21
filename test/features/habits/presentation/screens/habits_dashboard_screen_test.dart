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
import 'package:lifeos/features/habits/domain/contracts/habits_summary.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/features/habits/presentation/screens/habits_dashboard_screen.dart';
import 'package:lifeos/features/reminders/presentation/providers/planning_workspace_section_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_dashboard_screen.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planning_workspace_scaffold.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
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

class _FixedSectionNotifier extends PlanningWorkspaceSectionNotifier {
  _FixedSectionNotifier(this._fixed);

  final PlanningWorkspaceSection _fixed;

  @override
  PlanningWorkspaceSection build() => _fixed;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpHabits(WidgetTester tester) async {
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
      initialLocation: '/reminders/habits',
      routes: [
        GoRoute(
          path: '/reminders',
          name: RouteNames.reminders,
          builder: (context, state) => const PlanningWorkspaceScaffold(
            remindersBody: RemindersDashboardScreen(),
            habitsBody: HabitsDashboardScreen(),
            calendarBody: CalendarDashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/reminders/habits',
          name: RouteNames.habits,
          redirect: (context, state) {
            final scopedContainer = ProviderScope.containerOf(context);
            Future.microtask(
              () => scopedContainer
                  .read(planningWorkspaceSectionProvider.notifier)
                  .select(PlanningWorkspaceSection.habits),
            );
            return '/reminders';
          },
        ),
        GoRoute(
          path: '/new-habit',
          name: RouteNames.newHabit,
          builder: (context, state) => const Scaffold(body: Text('New Habit')),
        ),
        GoRoute(
          path: '/habit-detail/:habitId',
          name: RouteNames.habitDetail,
          builder: (context, state) =>
              Scaffold(body: Text('Habit ${state.pathParameters['habitId']}')),
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

  testWidgets('renders the hero and an empty state with zero habits', (
    tester,
  ) async {
    await pumpHabits(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(HeroScaffold), findsOneWidget);
    expect(
      find.text('No habits yet — add one to start a streak'),
      findsOneWidget,
    );
    expect(find.text('Add Habit'), findsOneWidget);
  });

  testWidgets(
    'creating a habit updates the dashboard reactively without manual refresh',
    (tester) async {
      final container = await pumpHabits(tester);
      final repository = container.read(habitsRepositoryProvider);

      await repository.create(
        id: 'h1',
        title: 'Morning Walk',
        schedule: const HabitSchedule.daily(),
        icon: 'walk',
      );
      await tester.pumpAndSettle();

      expect(find.text('Morning Walk'), findsWidgets);
      expect(
        find.text('No habits yet — add one to start a streak'),
        findsNothing,
      );
    },
  );

  testWidgets('completing a habit today updates it reactively', (tester) async {
    final container = await pumpHabits(tester);
    final repository = container.read(habitsRepositoryProvider);

    await repository.create(
      id: 'h1',
      title: 'Drink Water',
      schedule: const HabitSchedule.daily(),
      icon: 'water',
    );
    await tester.pumpAndSettle();

    final controller = tester
        .widget<CustomScrollView>(find.byType(CustomScrollView))
        .controller!;
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    await repository.setCompletedForDate('h1', DateTime.now(), completed: true);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping Add Habit navigates to NewHabitScreen', (tester) async {
    await pumpHabits(tester);

    await tester.tap(find.text('Add Habit'));
    await tester.pumpAndSettle();

    expect(find.text('New Habit'), findsOneWidget);
  });

  testWidgets('tapping a habit tile opens HabitDetailScreen', (tester) async {
    final container = await pumpHabits(tester);
    final repository = container.read(habitsRepositoryProvider);

    await repository.create(
      id: 'h1',
      title: 'Read',
      schedule: const HabitSchedule.daily(),
      icon: 'book',
    );
    await tester.pumpAndSettle();

    final controller = tester
        .widget<CustomScrollView>(find.byType(CustomScrollView))
        .controller!;
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    await tester.tap(find.text('Read').first, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Habit h1'), findsOneWidget);
  });

  testWidgets('shows a loading treatment while the dashboard provider is '
      'still resolving, with the hero still visible', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider.overrideWithValue(
            PreferencesService(prefs),
          ),
          secureStorageServiceProvider.overrideWithValue(
            SecureStorageService(const _FakeSecureStorage({})),
          ),
          currentWorkspaceProvider.overrideWith(
            () => _FixedWorkspaceNotifier(WorkspaceIds.reminders),
          ),
          habitsDashboardProvider.overrideWithValue(
            const AsyncLoading<HabitsSummary>(),
          ),
          planningWorkspaceSectionProvider.overrideWith(
            () => _FixedSectionNotifier(PlanningWorkspaceSection.habits),
          ),
        ],
        child: const MaterialApp(
          home: PlanningWorkspaceScaffold(
            remindersBody: RemindersDashboardScreen(),
            habitsBody: HabitsDashboardScreen(),
            calendarBody: CalendarDashboardScreen(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(HeroScaffold), findsOneWidget);
    expect(find.byType(SectionLoadingPlaceholder), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows an error state with a retry action when the provider '
      'errors, with the hero shell still usable', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider.overrideWithValue(
            PreferencesService(prefs),
          ),
          secureStorageServiceProvider.overrideWithValue(
            SecureStorageService(const _FakeSecureStorage({})),
          ),
          currentWorkspaceProvider.overrideWith(
            () => _FixedWorkspaceNotifier(WorkspaceIds.reminders),
          ),
          habitsDashboardProvider.overrideWithValue(
            AsyncError<HabitsSummary>(Exception('boom'), StackTrace.empty),
          ),
          planningWorkspaceSectionProvider.overrideWith(
            () => _FixedSectionNotifier(PlanningWorkspaceSection.habits),
          ),
        ],
        child: const MaterialApp(
          home: PlanningWorkspaceScaffold(
            remindersBody: RemindersDashboardScreen(),
            habitsBody: HabitsDashboardScreen(),
            calendarBody: CalendarDashboardScreen(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(HeroScaffold), findsOneWidget);
    expect(find.text("Couldn't load your habits"), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders at a narrow phone width without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final container = await pumpHabits(tester);
    final repository = container.read(habitsRepositoryProvider);
    await repository.create(
      id: 'h1',
      title: 'A fairly long habit title that could overflow a narrow row',
      schedule: const HabitSchedule.daily(),
      icon: 'star',
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
