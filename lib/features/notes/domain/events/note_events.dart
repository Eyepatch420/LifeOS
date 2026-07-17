import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [NotesRepository] on note creation. The NotificationEngine
/// (Phase 3) is the first subscriber; no repository constructs a
/// notification directly (Architecture Constraint 5).
class NoteCreated extends DomainEvent {
  const NoteCreated({required String noteId})
    : super(sourceModule: 'notes', sourceId: noteId);
}
