import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/notes/domain/models/create_note_request.dart';
import 'package:lifeos/features/notes/presentation/providers/note_providers.dart';

void main() {
  ProviderContainer makeContainer() {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    return container;
  }

  test('noteRequestsProvider starts empty', () async {
    final container = makeContainer();
    expect(await container.read(noteRequestsProvider.future), isEmpty);
  });

  test(
    'addNote appends to the list and persists via NotesRepository',
    () async {
      final container = makeContainer();
      await container.read(noteRequestsProvider.future);

      final note = CreateNoteRequest(
        id: '1',
        title: 'Groceries',
        body: 'Milk, eggs',
        createdAt: DateTime(2026, 1, 1),
      );
      await container.read(noteRequestsProvider.notifier).addNote(note);

      expect(container.read(noteRequestsProvider).value, [note]);
    },
  );
}
