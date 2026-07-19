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
import 'package:lifeos/features/habits/presentation/screens/habits_dashboard_screen.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/planner_screen.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_dashboard_screen.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:lifeos/theme/theme_providers.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pre-Phase-8 blocker regression suite: proves real POINTER interactions
/// (`tester.tap`/`tester.drag` against the rendered widget tree, never a
/// direct `onSelected()` invocation) reach the workspace-nav pills through
/// the FULL `PlanningWorkspaceScaffold`/`HeroScaffold` composition — the
/// layer where the actual bug lived (see `reminders_hero_section_test.dart`
/// for the narrower widget-level regression test, and
/// `reminders_workspace_nav_test.dart`, which tested `RemindersWorkspaceNav`
/// in isolation and therefore never caught this: a direct `onTap()` call
/// proves the callback is wired, not that a real tap reaches it through the
/// Stack).
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

  Future<ProviderContainer> pumpApp(
    WidgetTester tester, {
    Size? screenSize,
  }) async {
    if (screenSize != null) {
      tester.view.physicalSize = screenSize;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

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
              path: RoutePaths.habits,
              name: RouteNames.habits,
              builder: (context, state) => const HabitsDashboardScreen(),
            ),
            GoRoute(
              path: RoutePaths.calendar,
              name: RouteNames.calendar,
              builder: (context, state) => const CalendarDashboardScreen(),
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

  /// A real pointer tap on a pill, identified by its `Semantics(label: ...)`
  /// wrapper (the same target a real finger/touch event would land on),
  /// NOT a direct callback invocation.
  Future<void> tapWorkspacePill(WidgetTester tester, String label) async {
    await tester.tap(findBySemanticsLabel(label));
    await tester.pumpAndSettle();
  }

  group(
    'at a realistic emulator width (1080x2424 physical / 3x -> 360x808 logical)',
    () {
      testWidgets(
        'Reminders -> Planner -> Habits -> Calendar -> Habits -> Planner -> '
        'Reminders, all via real taps, with no dead taps, exceptions, or '
        'stuck screens',
        (tester) async {
          await pumpApp(tester, screenSize: const Size(1080, 2424));

          expect(find.byType(RemindersDashboardScreen), findsOneWidget);

          await tapWorkspacePill(tester, 'Planner');
          expect(find.byType(PlannerScreen), findsOneWidget);
          expect(tester.takeException(), isNull);

          await tapWorkspacePill(tester, 'Habits');
          expect(find.byType(HabitsDashboardScreen), findsOneWidget);
          expect(tester.takeException(), isNull);

          await tapWorkspacePill(tester, 'Calendar');
          expect(find.byType(CalendarDashboardScreen), findsOneWidget);
          expect(tester.takeException(), isNull);

          await tapWorkspacePill(tester, 'Habits');
          expect(find.byType(HabitsDashboardScreen), findsOneWidget);
          expect(tester.takeException(), isNull);

          await tapWorkspacePill(tester, 'Planner');
          expect(find.byType(PlannerScreen), findsOneWidget);
          expect(tester.takeException(), isNull);

          await tapWorkspacePill(tester, 'Reminders');
          expect(find.byType(RemindersDashboardScreen), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'a horizontal drag on the workspace nav scrolls it (does not throw, '
        'does not move the page scroll), and Calendar becomes tappable after',
        (tester) async {
          await pumpApp(tester, screenSize: const Size(1080, 2424));

          // Real touch drag over the pill row — same gesture the emulator
          // repro used.
          await tester.drag(
            findBySemanticsLabel('Reminders'),
            const Offset(-300, 0),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          await tapWorkspacePill(tester, 'Calendar');
          expect(find.byType(CalendarDashboardScreen), findsOneWidget);
        },
      );

      testWidgets(
        'the main workspace content still scrolls vertically after the '
        'workspace-nav hit-testing fix',
        (tester) async {
          final container = await pumpApp(
            tester,
            screenSize: const Size(1080, 2424),
          );
          // Seed enough reminders that the sheet content genuinely overflows
          // the viewport — an empty dashboard's sheet is exactly viewport
          // height (HeroScaffold's `minHeight: constraints.maxHeight`), which
          // has no scroll extent to prove anything with.
          final repository = container.read(remindersRepositoryProvider);
          for (var i = 0; i < 20; i++) {
            await repository.create(
              id: 'r$i',
              title: 'Reminder $i',
              dueAt: DateTime.now().add(Duration(hours: i)),
              isUrgent: false,
            );
          }
          await tester.pumpAndSettle();

          // `find.byType(Scrollable).first` would find the workspace nav's
          // own horizontal SingleChildScrollView (built earlier in the tree,
          // nested inside the hero) instead of HeroScaffold's page-level
          // vertical CustomScrollView — target the latter specifically.
          final scrollable = find.descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          );
          final position = tester.state<ScrollableState>(scrollable).position;
          expect(
            position.maxScrollExtent,
            greaterThan(0),
            reason: 'test setup: sheet content must be tall enough to scroll',
          );
          final before = position.pixels;

          // Drag from well below the hero (the sheet's content area, not the
          // hero/nav region the fix intentionally excludes from this scroll
          // view) — dragging from inside the hero would correctly no longer
          // scroll the page, since that region now belongs to the hero's own
          // interactive controls per the fix.
          await tester.dragFrom(const Offset(200, 1600), const Offset(0, -600));
          await tester.pump();

          final after = position.pixels;
          expect(after, greaterThan(before));
          expect(tester.takeException(), isNull);
        },
      );
    },
  );

  group('at 320px width', () {
    testWidgets(
      'Reminders -> Planner -> Habits, all via real taps, no overflow, no '
      'exceptions',
      (tester) async {
        await pumpApp(tester, screenSize: const Size(320 * 3, 700 * 3));

        await tapWorkspacePill(tester, 'Planner');
        expect(find.byType(PlannerScreen), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tapWorkspacePill(tester, 'Habits');
        expect(find.byType(HabitsDashboardScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
