import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_dashboard_provider.dart';
import 'package:lifeos/features/lists/presentation/screens/list_detail_screen.dart';

void main() {
  Future<ProviderContainer> pump(WidgetTester tester, String listId) async {
    // closeStreamsSynchronously avoids a pending zero-duration Timer when
    // a QueryStream detaches on widget disposal — without it,
    // flutter_test's fake-async zone flags that as a leaked timer.
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    late ProviderContainer container;
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/list',
          builder: (context, state) => ListDetailScreen(listId: listId),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();
    // Pushed (not the initial location) so `context.pop()` inside the
    // screen (e.g. after archiving) has somewhere to go back to — matches
    // real usage, where ListDetailScreen is always reached via a push.
    router.push('/list');
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('shows EmptyState fallback for an unknown list id', (
    tester,
  ) async {
    await pump(tester, 'missing');
    await tester.pump();

    expect(find.text('This list no longer exists'), findsOneWidget);
  });

  testWidgets('renders items and toggling a checkbox marks it done', (
    tester,
  ) async {
    final container = await pump(tester, 'l1');
    // listsRepositoryProvider defaults to auto-dispose (Riverpod 3.x) — a
    // plain container.read() with no active listener can race the
    // provider's own disposal.
    final sub = container.listen(listsRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(listsRepositoryProvider);
    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await repository.addItem(
      id: 'i1',
      listId: 'l1',
      label: 'Milk',
      sortOrder: 0,
    );
    await tester.pumpAndSettle();

    expect(find.text('Milk'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    final list = await repository.watchById('l1').first;
    expect(list!.items.single.isDone, isTrue);
  });

  testWidgets('archiving pops the screen', (tester) async {
    final container = await pump(tester, 'l1');
    final sub = container.listen(listsRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(listsRepositoryProvider);
    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Archive List'));
    await tester.pumpAndSettle();

    final list = await repository.watchById('l1').first;
    expect(list, isNull);
  });
}
