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
import 'package:lifeos/features/calendar/presentation/providers/calendar_dashboard_provider.dart';
import 'package:lifeos/features/calendar/presentation/screens/calendar_dashboard_screen.dart';
import 'package:lifeos/features/calendar/presentation/screens/event_detail_screen.dart';
import 'package:lifeos/features/calendar/presentation/screens/new_event_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/planner_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_dashboard_screen.dart';
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

/// Router integration test focused on the Calendar routes added in Phase
/// 7, mirroring `habits_routing_test.dart`'s exact shape/harness.
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
          builder: (context, state) => const RemindersDashboardScreen(),
          routes: [
            GoRoute(
              path: RoutePaths.planner,
              name: RouteNames.planner,
              builder: (context, state) => const PlannerScreen(),
            ),
            GoRoute(
              path: RoutePaths.calendar,
              name: RouteNames.calendar,
              builder: (context, state) => const CalendarDashboardScreen(),
            ),
            GoRoute(
              path: RoutePaths.newEvent,
              name: RouteNames.newEvent,
              builder: (context, state) => NewEventScreen(
                initialDate: state.extra is DateTime
                    ? state.extra! as DateTime
                    : null,
              ),
            ),
            GoRoute(
              path: RoutePaths.eventDetail,
              name: RouteNames.eventDetail,
              builder: (context, state) =>
                  EventDetailScreen(eventId: state.pathParameters['eventId']!),
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
    return container;
  }

  void tapWorkspaceNavItem(WidgetTester tester, String label) {
    final semantics = findBySemanticsLabel(label);
    final gestureDetector = find
        .ancestor(of: semantics, matching: find.byType(GestureDetector))
        .first;
    (tester.widget(gestureDetector) as GestureDetector).onTap!();
  }

  testWidgets('/reminders/calendar is a static route reached from the '
      'Reminders workspace nav', (tester) async {
    await pumpApp(tester);

    tapWorkspaceNavItem(tester, 'Calendar');
    await tester.pumpAndSettle();

    expect(find.byType(CalendarDashboardScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Calendar workspace nav Planner tile navigates to Planner', (
    tester,
  ) async {
    await pumpApp(tester);

    tapWorkspaceNavItem(tester, 'Calendar');
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDashboardScreen), findsOneWidget);

    tapWorkspaceNavItem(tester, 'Planner');
    await tester.pumpAndSettle();

    expect(find.byType(PlannerScreen), findsOneWidget);
  });

  testWidgets(
    'goNamed(newEvent) resolves to the static NewEventScreen route, not '
    'EventDetailScreen with an eventId of "new" — static-before-dynamic '
    'route declaration order (see route_paths.dart\'s doc comment)',
    (tester) async {
      await pumpApp(tester);

      GoRouter.of(
        tester.element(find.byType(RemindersDashboardScreen)),
      ).goNamed(RouteNames.newEvent);
      await tester.pumpAndSettle();

      expect(find.byType(NewEventScreen), findsOneWidget);
      expect(find.byType(EventDetailScreen), findsNothing);
    },
  );

  testWidgets('Calendar -> open an event detail -> back returns to '
      'Calendar unchanged', (tester) async {
    final container = await pumpApp(tester);
    await container
        .read(eventsRepositoryProvider)
        .create(
          id: 'e1',
          title: 'Standup',
          startAt: DateTime.now().add(const Duration(hours: 1)),
          isAllDay: false,
        );

    tapWorkspaceNavItem(tester, 'Calendar');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Standup').first, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(EventDetailScreen), findsOneWidget);

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pop();
    await tester.pumpAndSettle();

    expect(find.byType(CalendarDashboardScreen), findsOneWidget);
  });

  testWidgets('Calendar Add Event -> back returns to Calendar', (tester) async {
    await pumpApp(tester);

    tapWorkspaceNavItem(tester, 'Calendar');
    await tester.pumpAndSettle();

    // The empty-state's "Add Event" CTA can render below the visible
    // viewport at this screen size, so `tap()`'s hit-test can miss it
    // silently even with `warnIfMissed: false` — invoke the button's
    // callback directly instead, same as this file's other off-screen-safe
    // interactions.
    final ctaButton = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('Add Event').first,
        matching: find.byType(TextButton),
      ),
    );
    ctaButton.onPressed?.call();
    await tester.pumpAndSettle();

    expect(find.byType(NewEventScreen), findsOneWidget);

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pop();
    await tester.pumpAndSettle();

    expect(find.byType(CalendarDashboardScreen), findsOneWidget);
  });

  testWidgets(
    'Planner shows a timed event today and tapping it opens EventDetailScreen '
    '(no complete action rendered)',
    (tester) async {
      final container = await pumpApp(tester);
      await container
          .read(eventsRepositoryProvider)
          .create(
            id: 'e1',
            title: 'Design Review',
            startAt: DateTime.now().add(const Duration(hours: 1)),
            isAllDay: false,
          );

      tapWorkspaceNavItem(tester, 'Planner');
      await tester.pumpAndSettle();

      expect(find.byType(PlannerScreen), findsOneWidget);
      expect(find.text('Design Review'), findsOneWidget);
      expect(
        findBySemanticsLabel('Mark Design Review as completed'),
        findsNothing,
      );

      await tester.tap(find.text('Design Review'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(EventDetailScreen), findsOneWidget);
    },
  );
}
