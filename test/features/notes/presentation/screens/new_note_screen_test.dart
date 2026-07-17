import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/notes/presentation/providers/note_providers.dart';
import 'package:lifeos/features/notes/presentation/screens/new_note_screen.dart';

void main() {
  Future<GoRouter> pump(WidgetTester tester, AppDatabase db) async {
    final router = GoRouter(
      initialLocation: '/note',
      routes: [
        GoRoute(
          path: '/note',
          builder: (context, state) => const NewNoteScreen(),
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
    return router;
  }

  testWidgets('renders title/body fields and a Save Note CTA', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await pump(tester, db);

    expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Note'), findsOneWidget);
    expect(find.text('Save Note'), findsOneWidget);
  });

  testWidgets('saving adds a note and pops', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    late ProviderContainer container;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/note',
          builder: (context, state) => const NewNoteScreen(),
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

    // noteRequestsProvider is not autoDispose-exempt (Riverpod 3.x defaults
    // every provider to auto-dispose) — a plain container.read() after
    // NewNoteScreen pops and its ref stops listening would race the
    // provider's own disposal. Hold a listener open for the container's
    // whole lifetime so the assertion below reads live state, exactly as a
    // real app screen elsewhere in the tree would if it also depended on
    // this provider surviving the New Note screen's pop.
    final sub = container.listen(noteRequestsProvider, (_, _) {});
    addTearDown(sub.close);

    router.push('/note');
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Test');
    await tester.tap(find.text('Save Note'));
    await tester.pumpAndSettle();

    expect(container.read(noteRequestsProvider).value?.length, 1);
  });
}
