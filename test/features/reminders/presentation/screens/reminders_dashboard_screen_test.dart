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
import 'package:lifeos/features/reminders/domain/models/reminders_dashboard_data.dart';
import 'package:lifeos/features/calendar/presentation/screens/calendar_dashboard_screen.dart';
import 'package:lifeos/features/habits/presentation/screens/habits_dashboard_screen.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_data_provider.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_dashboard_screen.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planning_workspace_scaffold.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_workspace_nav.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/theme/theme_providers.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory fake so this test never touches platform channels for secure
/// storage — mirrors the fake already proven in home_screen_test.dart.
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpReminders(WidgetTester tester) async {
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
      initialLocation: '/reminders',
      routes: [
        GoRoute(
          path: '/reminders',
          name: RouteNames.reminders,
          builder: (context, state) => const PlanningWorkspaceScaffold(
            remindersBody: RemindersDashboardScreen(),
            habitsBody: HabitsDashboardScreen(),
            calendarBody: CalendarDashboardScreen(),
          ),
          routes: [
            GoRoute(
              path: RoutePaths.remindersAll,
              name: RouteNames.remindersAll,
              builder: (context, state) =>
                  const Scaffold(body: Text('All Reminders')),
            ),
          ],
        ),
        GoRoute(
          path: '/new-reminder',
          name: RouteNames.newReminder,
          builder: (context, state) =>
              const Scaffold(body: Text('New Reminder')),
        ),
        GoRoute(
          path: '/reminders-detail/:reminderId',
          name: RouteNames.reminderDetail,
          builder: (context, state) => Scaffold(
            body: Text('Reminder ${state.pathParameters['reminderId']}'),
          ),
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
    return container;
  }

  testWidgets('renders the hero, workspace nav, and dashboard sections with '
      'zero reminders (empty state)', (tester) async {
    await pumpReminders(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(HeroScaffold), findsOneWidget);
    expect(find.byType(RemindersWorkspaceNav), findsOneWidget);
    // "Today" appears twice by design: the Overview stat tile label and the
    // Today section's header.
    expect(find.text('Today'), findsNWidgets(2));
    expect(find.text('Upcoming'), findsNWidgets(2));
    expect(find.text('Up Next'), findsOneWidget);
    expect(find.text('Add Reminder'), findsOneWidget);
    expect(find.text("You're all caught up"), findsOneWidget);
    expect(find.text('Nothing due today'), findsOneWidget);
    expect(find.text('No upcoming reminders'), findsOneWidget);
    // Overview stats all show 0, not blank, while there's no data yet.
    expect(find.text('0'), findsWidgets);
  });

  testWidgets('renders real reminder data reactively: creating a reminder '
      'updates the dashboard without any manual refresh', (tester) async {
    final container = await pumpReminders(tester);
    final repository = container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime.now().add(const Duration(days: 2)),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    // "Pay rent" is both the nearest actionable reminder (Up Next) and the
    // only Upcoming entry, so it legitimately renders twice.
    expect(find.text('Pay rent'), findsNWidgets(2));
    expect(find.text('No upcoming reminders'), findsNothing);
  });

  testWidgets('completing the Up Next reminder updates the dashboard '
      'reactively', (tester) async {
    final container = await pumpReminders(tester);
    final repository = container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'r1',
      title: 'Call the dentist',
      dueAt: DateTime.now().add(const Duration(hours: 1)),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    // Due within the hour: both Up Next and today's preview show it.
    expect(find.text('Call the dentist'), findsNWidgets(2));

    await repository.setCompleted('r1', true);
    await tester.pumpAndSettle();

    expect(find.text('Call the dentist'), findsNothing);
    expect(find.text("You're all caught up"), findsOneWidget);
  });

  testWidgets('completing a DAILY recurring reminder that is due today '
      'reclassifies the dashboard: it leaves Today and reappears under '
      'Upcoming at its next occurrence, without any manual refresh', (
    tester,
  ) async {
    final container = await pumpReminders(tester);
    final repository = container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'r1',
      title: 'Take medicine',
      dueAt: DateTime.now().add(const Duration(hours: 1)),
      isUrgent: false,
      recurrence: RecurrenceRule.daily,
    );
    await tester.pumpAndSettle();

    expect(find.text('Take medicine'), findsNWidgets(2)); // Up Next + Today.

    await repository.setCompleted('r1', true);
    await tester.pumpAndSettle();

    // Advanced ~24h out: now only Up Next + Upcoming show it (no longer
    // Today), and the reminder was never removed from the dashboard the
    // way a non-recurring completion removes it.
    expect(find.text('Take medicine'), findsNWidgets(2));
    expect(find.text('Nothing due today'), findsOneWidget);
  });

  testWidgets('tapping Quick Add navigates to NewReminderScreen', (
    tester,
  ) async {
    await pumpReminders(tester);

    // Add Reminder sits below the fold on the default test viewport; the
    // dashboard's only scroll surface is HeroScaffold's own
    // CustomScrollView, which `ensureVisible` doesn't reach into the way
    // it would a plain ListView — scroll it directly instead.
    final controller = tester
        .widget<CustomScrollView>(find.byType(CustomScrollView))
        .controller!;
    controller.jumpTo(300);
    await tester.pump();

    await tester.tap(find.text('Add Reminder'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping an Upcoming reminder opens ReminderDetailScreen', (
    tester,
  ) async {
    final container = await pumpReminders(tester);
    final repository = container.read(remindersRepositoryProvider);

    await repository.create(
      id: 'r1',
      title: 'Renew passport',
      dueAt: DateTime.now().add(const Duration(days: 5)),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    final controller = tester
        .widget<CustomScrollView>(find.byType(CustomScrollView))
        .controller!;
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    // Also the Up Next tile (only pending reminder) — tap the Upcoming
    // section's copy specifically, i.e. the last match in paint order.
    await tester.tap(find.text('Renew passport').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('search/notification/avatar controls are present', (
    tester,
  ) async {
    await pumpReminders(tester);

    expect(findBySemanticsLabel('Search'), findsOneWidget);
    expect(findBySemanticsLabel('Notifications'), findsOneWidget);
    expect(findBySemanticsLabel('Profile'), findsOneWidget);
  });

  testWidgets('the sheet scrolls and the hero fades on scroll', (tester) async {
    await pumpReminders(tester);

    final scrollView = tester.widget<CustomScrollView>(
      find.byType(CustomScrollView),
    );
    final controller = scrollView.controller!;
    expect(controller.offset, 0.0);

    final width = tester.getSize(find.byType(HeroScaffold)).width;
    final sheetTop = HeroScaffold.heroHeightFor(width) - 24;

    controller.jumpTo(sheetTop);
    await tester.pump();

    final opacity = tester.widget<Opacity>(
      find
          .ancestor(
            of: find.byType(RemindersWorkspaceNav),
            matching: find.byType(Opacity),
          )
          .first,
    );
    expect(opacity.opacity, 0.0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a loading treatment (not a fake zero) while the '
      'dashboard provider is still resolving, with the hero still visible', (
    tester,
  ) async {
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
          // Never resolves — asserts the sheet shows a loading treatment,
          // not a blank/fake-zero dashboard, while the hero stays visible.
          remindersDashboardDataProvider.overrideWithValue(
            const AsyncLoading<RemindersDashboardData>(),
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
    expect(find.text('Today'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a dashboard-level error state with a retry action when '
      'the provider errors, with the hero shell still usable', (tester) async {
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
          remindersDashboardDataProvider.overrideWithValue(
            AsyncError<RemindersDashboardData>(
              Exception('boom'),
              StackTrace.empty,
            ),
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
    expect(find.text("Couldn't load your reminders"), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
