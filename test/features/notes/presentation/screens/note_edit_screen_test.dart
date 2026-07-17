import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';
import 'package:lifeos/features/notes/presentation/screens/note_edit_screen.dart';

void main() {
  Future<ProviderContainer> pump(WidgetTester tester, String noteId) async {
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
          path: '/edit',
          builder: (context, state) => NoteEditScreen(noteId: noteId),
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
    router.push('/edit');
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('shows EmptyState fallback for an unknown note id', (
    tester,
  ) async {
    await pump(tester, 'missing');
    await tester.pump();

    expect(find.text('This note no longer exists'), findsOneWidget);
  });

  testWidgets('pre-fills fields from the existing note and saves edits', (
    tester,
  ) async {
    final container = await pump(tester, 'n1');
    final sub = container.listen(notesRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(notesRepositoryProvider);
    await repository.create(id: 'n1', title: 'Groceries', body: 'Milk');
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Groceries v2',
    );
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    final note = await repository.getById('n1');
    expect(note!.title, 'Groceries v2');
  });
}
