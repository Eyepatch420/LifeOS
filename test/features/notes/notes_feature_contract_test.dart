import 'package:drift/native.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/notes/data/repositories/notes_repository.dart';
import 'package:lifeos/features/notes/domain/contracts/recent_notes_summary.dart';
import 'package:lifeos/features/notes/domain/events/note_events.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_notification_contributor.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_search_contributor.dart';

import '../../contracts/feature_contract_test_harness.dart';

/// The reference usage of `runFeatureContractTests` — every future Type A
/// feature's contract test follows this exact shape.
void main() {
  runFeatureContractTests<RecentNotesSummary>('Notes', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final eventBus = EventBus();
    final repository = NotesRepository(db.notesDao, eventBus);

    // Seeded before the fixture is returned so every sub-test
    // (dashboard/search/notification) sees this note, not just whichever
    // sub-test happens to run first.
    await repository.create(id: 'n1', title: 'Seed', body: 'Seed body');

    return FeatureContractFixture<RecentNotesSummary>(
      dashboardSummary: () async {
        final notes = await repository.watchAll().first;
        return RecentNotesSummary(
          notes: [
            for (final note in notes)
              RecentNoteSummary(
                id: note.id,
                title: note.title,
                preview: note.body,
                timestamp: 'now',
                isPinned: note.isPinned,
              ),
          ],
        );
      },
      searchContributor: NotesSearchContributor(repository),
      notificationContributor: const NotesNotificationContributor(),
      sampleOwnEvent: const NoteCreated(noteId: 'n1'),
      triggerNotifiableMutation: () =>
          repository.create(id: 'n2', title: 'Trigger', body: 'Trigger body'),
    );
  });
}
