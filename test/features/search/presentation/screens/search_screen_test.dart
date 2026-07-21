import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/navigation/presentation/providers/bottom_nav_providers.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';
import 'package:lifeos/features/search/domain/search_registry.dart';
import 'package:lifeos/features/search/presentation/providers/search_registry_provider.dart';
import 'package:lifeos/features/search/presentation/screens/search_screen.dart';

class _FakeContributor implements SearchContributor {
  const _FakeContributor(this.entity);

  final SearchableEntity entity;

  @override
  Stream<List<SearchableEntity>> contributions() => Stream.value([entity]);
}

void main() {
  Future<GoRouter> pump(
    WidgetTester tester, {
    Widget Function(Widget child)? wrap,
    List<GoRoute> extraRoutes = const [],
  }) async {
    // The full mock index (notes + lists + up-next + 4 tab placeholders)
    // doesn't fit a default 800x600 test surface, and ListView only builds
    // visible children — grow the surface so every result renders without
    // scroll gymnastics.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/search',
      routes: [
        GoRoute(
          path: '/health',
          name: RouteNames.health,
          builder: (context, state) => const Scaffold(body: Text('Health')),
        ),
        GoRoute(
          path: '/reminders',
          name: RouteNames.reminders,
          builder: (context, state) =>
              const Scaffold(body: Text('Reminders tab')),
        ),
        GoRoute(
          path: '/search',
          name: RouteNames.search,
          builder: (context, state) => const SearchScreen(),
        ),
        ...extraRoutes,
      ],
    );
    final app = MaterialApp.router(routerConfig: router);
    await tester.pumpWidget(
      wrap != null ? wrap(app) : ProviderScope(child: app),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('shows the full index before typing anything', (tester) async {
    await pump(tester);

    expect(find.text('Health'), findsOneWidget);
    expect(find.text('Finance'), findsOneWidget);
  });

  testWidgets('typing filters the result list', (tester) async {
    await pump(tester);

    await tester.enterText(find.byType(TextField), 'health');
    await tester.pump();

    expect(find.text('Health'), findsOneWidget);
    expect(find.text('Finance'), findsNothing);
  });

  testWidgets('a query matching nothing shows the empty state', (tester) async {
    await pump(tester);

    await tester.enterText(find.byType(TextField), 'zzz_no_such_thing_zzz');
    await tester.pumpAndSettle();

    expect(find.text('No results'), findsOneWidget);
  });

  testWidgets('tapping a tab result navigates to that tab', (tester) async {
    await pump(tester);

    await tester.tap(find.widgetWithText(ListTile, 'Health'));
    await tester.pumpAndSettle();

    expect(find.text('Health'), findsOneWidget);
    expect(find.byType(SearchScreen), findsNothing);
  });

  testWidgets(
    'hides the current tab (Home, the default) from the index but shows '
    'the others',
    (tester) async {
      await pump(tester);

      expect(find.text('Home'), findsNothing);
      expect(find.text('Reminders'), findsOneWidget);
      expect(find.text('Health'), findsOneWidget);
    },
  );

  testWidgets('hides Reminders instead when that tab is active', (
    tester,
  ) async {
    await pump(tester);

    // bottomNavIndexProvider defaults to 0 on build; drive it to the
    // Reminders branch (index 1) the same way the bottom nav would.
    final element = tester.element(find.byType(SearchScreen));
    ProviderScope.containerOf(
      element,
    ).read(bottomNavIndexProvider.notifier).setIndex(1);
    await tester.pumpAndSettle();

    expect(find.text('Reminders'), findsNothing);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Health'), findsOneWidget);
  });

  // Regression coverage for the bug where NotesSearchContributor,
  // ListsSearchContributor, and RemindersSearchContributor all supplied a
  // real routeName/pathParameters for an existing detail route, but
  // SearchScreen's tap handler routed those categories into a stale
  // "no detail screen yet — pop" branch instead of pushing to it.
  testWidgets('tapping a reminder result pushes the reminder detail route', (
    tester,
  ) async {
    const entity = SearchableEntity(
      id: 'reminder-abc',
      title: 'Buy milk',
      subtitle: 'Due today',
      icon: Icons.notifications_outlined,
      category: SearchableEntityCategory.reminder,
      routeName: RouteNames.reminderDetail,
      pathParameters: {'reminderId': 'abc'},
    );

    await pump(
      tester,
      wrap: (child) => ProviderScope(
        overrides: [
          searchRegistryProvider.overrideWithValue(
            SearchRegistry([const _FakeContributor(entity)]),
          ),
        ],
        child: child,
      ),
      extraRoutes: [
        GoRoute(
          path: '/reminders/:reminderId',
          name: RouteNames.reminderDetail,
          builder: (context, state) => Scaffold(
            body: Text('Reminder ${state.pathParameters['reminderId']}'),
          ),
        ),
      ],
    );

    await tester.tap(find.widgetWithText(ListTile, 'Buy milk'));
    await tester.pumpAndSettle();

    expect(find.text('Reminder abc'), findsOneWidget);
    expect(find.byType(SearchScreen), findsNothing);
  });
}
