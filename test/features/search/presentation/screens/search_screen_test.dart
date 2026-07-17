import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/search/presentation/screens/search_screen.dart';

void main() {
  Future<GoRouter> pump(WidgetTester tester) async {
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
          path: '/search',
          name: RouteNames.search,
          builder: (context, state) => const SearchScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
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
}
