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
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/presentation/providers/planner_selected_date_provider.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/planner_screen.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_workspace_nav.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<({ProviderContainer container, AppDatabase db})> pumpPlanner(
    WidgetTester tester,
  ) async {
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
      initialLocation: '/reminders/planner',
      routes: [
        GoRoute(
          path: '/reminders',
          name: RouteNames.reminders,
          builder: (context, state) =>
              const Scaffold(body: Text('Reminders Dashboard')),
          routes: [
            GoRoute(
              path: RoutePaths.planner,
              name: RouteNames.planner,
              builder: (context, state) => const PlannerScreen(),
            ),
            GoRoute(
              path: RoutePaths.newReminder,
              name: RouteNames.newReminder,
              builder: (context, state) => Scaffold(
                body: Text(
                  'New Reminder ${state.extra is DateTime ? (state.extra! as DateTime).toIso8601String() : ''}',
                ),
              ),
            ),
            GoRoute(
              path: RoutePaths.reminderDetail,
              name: RouteNames.reminderDetail,
              builder: (context, state) => Scaffold(
                body: Text('Reminder ${state.pathParameters['reminderId']}'),
              ),
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
    await tester.pump();
    await tester.pump();
    return (container: container, db: db);
  }

  testWidgets('renders the hero, Planner-active workspace nav, header, and '
      'empty state with zero reminders', (tester) async {
    await pumpPlanner(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(HeroScaffold), findsOneWidget);
    expect(find.byType(RemindersWorkspaceNav), findsOneWidget);
    final nav = tester.widget<RemindersWorkspaceNav>(
      find.byType(RemindersWorkspaceNav),
    );
    expect(nav.selectedIndex, 1);
    expect(find.text('Today'), findsWidgets);
    expect(find.text('Nothing planned for this day'), findsOneWidget);
  });

  testWidgets('previous/next day change the header label', (tester) async {
    final result = await pumpPlanner(tester);

    expect(find.text('Today'), findsWidgets);

    result.container.read(plannerSelectedDateProvider.notifier).nextDay();
    await tester.pump();
    expect(find.text('Tomorrow'), findsOneWidget);

    result.container.read(plannerSelectedDateProvider.notifier).previousDay();
    await tester.pump();
    expect(find.text('Today'), findsWidgets);

    result.container.read(plannerSelectedDateProvider.notifier).previousDay();
    await tester.pump();
    expect(find.text('Yesterday'), findsOneWidget);
  });

  testWidgets('Today action is hidden when today is selected and appears '
      'once another date is selected', (tester) async {
    final result = await pumpPlanner(tester);

    expect(find.text('Today'), findsWidgets);
    // Only the header label + date-strip today indicator context, not the
    // "Today" jump action chip — verified by tapping previous day first.
    result.container.read(plannerSelectedDateProvider.notifier).nextDay();
    await tester.pump();

    final todayChip = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.label == 'Jump to today' &&
          widget.properties.button == true,
    );
    expect(todayChip, findsOneWidget);

    result.container.read(plannerSelectedDateProvider.notifier).resetToToday();
    await tester.pump();
    expect(todayChip, findsNothing);
  });

  testWidgets('populated day shows items in chronological order', (
    tester,
  ) async {
    final result = await pumpPlanner(tester);
    final today = DateTime.now();
    final repository = result.container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'late',
      title: 'Evening task',
      dueAt: DateTime(today.year, today.month, today.day, 18),
      isUrgent: false,
    );
    await repository.create(
      id: 'early',
      title: 'Morning task',
      dueAt: DateTime(today.year, today.month, today.day, 7),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    final earlyCenter = tester.getCenter(find.text('Morning task'));
    final lateCenter = tester.getCenter(find.text('Evening task'));
    expect(earlyCenter.dy, lessThan(lateCenter.dy));
  });

  testWidgets('urgent reminder is visually distinguished', (tester) async {
    final result = await pumpPlanner(tester);
    final today = DateTime.now();
    final repository = result.container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'urgent',
      title: 'Urgent task',
      dueAt: DateTime(today.year, today.month, today.day, 10),
      isUrgent: true,
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.priority_high_rounded), findsOneWidget);
  });

  testWidgets('recurring reminder shows the repeat indicator', (tester) async {
    final result = await pumpPlanner(tester);
    final today = DateTime.now();
    final repository = result.container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'recurring',
      title: 'Take medicine',
      dueAt: DateTime(today.year, today.month, today.day, 10),
      isUrgent: false,
      recurrence: RecurrenceRule.daily,
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.repeat), findsOneWidget);
  });

  testWidgets('completed reminder shows the completed check icon', (
    tester,
  ) async {
    final result = await pumpPlanner(tester);
    final today = DateTime.now();
    final repository = result.container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'done',
      title: 'Finished task',
      dueAt: DateTime(today.year, today.month, today.day, 10),
      isUrgent: false,
    );
    await repository.setCompleted('done', true);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('tapping a timeline item opens ReminderDetailScreen', (
    tester,
  ) async {
    final result = await pumpPlanner(tester);
    final today = DateTime.now();
    final repository = result.container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(today.year, today.month, today.day, 10),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pay rent'));
    await tester.pumpAndSettle();

    expect(find.text('Reminder r1'), findsOneWidget);
  });

  testWidgets('completing a non-recurring reminder marks it completed', (
    tester,
  ) async {
    final result = await pumpPlanner(tester);
    final today = DateTime.now();
    final repository = result.container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(today.year, today.month, today.day, 10),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pump();

    final reminder = await repository.getById('r1');
    expect(reminder!.isCompleted, isTrue);
    expect(find.text('Reminder completed'), findsOneWidget);
  });

  testWidgets('completing a recurring reminder advances it to the next '
      'occurrence and it leaves today\'s timeline', (tester) async {
    final result = await pumpPlanner(tester);
    final today = DateTime.now();
    final repository = result.container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'r1',
      title: 'Take medicine',
      dueAt: DateTime(today.year, today.month, today.day, 10),
      isUrgent: false,
      recurrence: RecurrenceRule.daily,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pump();

    expect(find.textContaining('Next reminder:'), findsOneWidget);

    final reminder = await repository.getById('r1');
    expect(reminder!.isCompleted, isFalse);
    expect(
      reminder.dueAt,
      DateTime(today.year, today.month, today.day + 1, 10),
    );

    await tester.pumpAndSettle();
    expect(find.text('Take medicine'), findsNothing);
  });

  testWidgets('Add Reminder from an empty day opens NewReminderScreen with '
      'the selected date prefilled', (tester) async {
    final result = await pumpPlanner(tester);
    result.container
        .read(plannerSelectedDateProvider.notifier)
        .selectDate(DateTime(2026, 8, 20));
    await tester.pumpAndSettle();

    final controller = tester
        .widget<CustomScrollView>(find.byType(CustomScrollView))
        .controller!;
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Reminder'));
    await tester.pumpAndSettle();

    expect(find.textContaining('2026-08-20'), findsOneWidget);
  });

  testWidgets('date strip renders 7 days and tapping one selects it', (
    tester,
  ) async {
    final result = await pumpPlanner(tester);
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);

    await tester.tap(find.text('${tomorrow.day}'));
    await tester.pump();

    expect(
      result.container.read(plannerSelectedDateProvider),
      DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
    );
  });

  testWidgets('does not overflow at a narrow phone width', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpPlanner(tester);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
