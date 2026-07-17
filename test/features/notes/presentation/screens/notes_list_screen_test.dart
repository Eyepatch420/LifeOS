import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';
import 'package:lifeos/features/notes/presentation/screens/notes_list_screen.dart';

void main() {
  Future<ProviderContainer> pump(WidgetTester tester) async {
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
      initialLocation: '/notes',
      routes: [
        GoRoute(
          path: '/notes',
          builder: (context, state) => const NotesListScreen(),
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
    return container;
  }

  testWidgets('shows empty state when no notes exist', (tester) async {
    await pump(tester);
    await tester.pump();

    expect(find.text('No notes yet'), findsOneWidget);
  });

  testWidgets('renders a tile per note and filters by title', (tester) async {
    final container = await pump(tester);
    final sub = container.listen(notesRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(notesRepositoryProvider);
    await repository.create(id: 'n1', title: 'Groceries', body: 'Milk');
    await repository.create(id: 'n2', title: 'Project Ideas', body: 'LifeOS');
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Project Ideas'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Grocer');
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Project Ideas'), findsNothing);
  });

  testWidgets('tapping the pin icon toggles pinned state', (tester) async {
    final container = await pump(tester);
    final sub = container.listen(notesRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(notesRepositoryProvider);
    await repository.create(id: 'n1', title: 'Groceries', body: 'Milk');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.push_pin_outlined));
    await tester.pumpAndSettle();

    final note = await repository.getById('n1');
    expect(note!.isPinned, isTrue);
  });
}
