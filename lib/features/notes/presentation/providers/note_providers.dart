import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/notes/domain/models/create_note_request.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';

/// [CreateNoteRequest] stays the form payload `NewNoteScreen`/`NoteEditScreen`
/// submit; `addNote` now persists via [NotesRepository] instead of holding
/// an in-memory list, but the notifier's public API is unchanged — no
/// call-site elsewhere needed to change for this swap (the seam promised
/// since Module 3).
class NoteRequestsNotifier extends AsyncNotifier<List<CreateNoteRequest>> {
  @override
  Future<List<CreateNoteRequest>> build() async => const [];

  Future<void> addNote(CreateNoteRequest note) async {
    await ref
        .read(notesRepositoryProvider)
        .create(id: note.id, title: note.title, body: note.body);
    state = AsyncData([...?state.value, note]);
  }
}

final noteRequestsProvider =
    AsyncNotifierProvider<NoteRequestsNotifier, List<CreateNoteRequest>>(
      NoteRequestsNotifier.new,
    );
