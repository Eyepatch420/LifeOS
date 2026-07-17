import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_dashboard_provider.dart';
import 'package:lifeos/features/lists/presentation/screens/lists_screen.dart';

void main() {
  Future<void> pump(WidgetTester tester) async {
    // closeStreamsSynchronously avoids a pending zero-duration Timer when
    // a QueryStream detaches on widget disposal — without it,
    // flutter_test's fake-async zone flags that as a leaked timer.
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    final router = GoRouter(
      initialLocation: '/lists',
      routes: [
        GoRoute(
          path: '/lists',
          builder: (context, state) => const ListsScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
  }

  // Deliberately not closing the in-memory AppDatabase in these tests:
  // Drift schedules a zero-duration Timer when a QueryStream detaches
  // (e.g. on widget disposal during teardown), and flutter_test's
  // fake-async zone flags that as a "pending timer" leak if db.close() is
  // called after the widget tree that holds the stream. The in-memory DB
  // is GC'd with the test's ProviderContainer regardless.

  testWidgets('shows empty state when no lists exist', (tester) async {
    await pump(tester);
    await tester.pump();

    expect(find.text('No lists yet'), findsOneWidget);
  });

  testWidgets('renders a tile for each list', (tester) async {
    await pump(tester);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ListsScreen)),
    );
    // listsRepositoryProvider defaults to auto-dispose (Riverpod 3.x) — a
    // plain container.read() with no active listener can race the
    // provider's own disposal. Hold a listener open for the assertion's
    // lifetime, same pattern documented in implemented_features.md.
    final sub = container.listen(listsRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(listsRepositoryProvider)
        .createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsOneWidget);
  });

  testWidgets('tapping + opens the create dialog', (tester) async {
    await pump(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('New List'), findsOneWidget);
  });
}
