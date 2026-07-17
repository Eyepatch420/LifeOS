import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';
import 'package:lifeos/features/notes/presentation/screens/note_detail_screen.dart';

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
          path: '/note',
          builder: (context, state) => NoteDetailScreen(noteId: noteId),
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
    router.push('/note');
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

  testWidgets('renders the note title and markdown body', (tester) async {
    final container = await pump(tester, 'n1');
    final sub = container.listen(notesRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(notesRepositoryProvider)
        .create(id: 'n1', title: 'Groceries', body: 'Milk and eggs');
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsWidgets);
    expect(find.textContaining('Milk and eggs'), findsOneWidget);
  });

  testWidgets('tapping Pin toggles pinned state', (tester) async {
    final container = await pump(tester, 'n1');
    final sub = container.listen(notesRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(notesRepositoryProvider);
    await repository.create(id: 'n1', title: 'Groceries', body: 'Milk');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pin'));
    await tester.pumpAndSettle();

    final note = await repository.getById('n1');
    expect(note!.isPinned, isTrue);
  });
}
