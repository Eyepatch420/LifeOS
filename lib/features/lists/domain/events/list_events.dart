import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [ListsRepository] on list creation. Mirrors `NoteCreated` —
/// the NotificationEngine (Phase 3) is the first subscriber; no repository
/// constructs a notification directly (Architecture Constraint 5).
class ListCreated extends DomainEvent {
  const ListCreated({required String listId})
    : super(sourceModule: 'lists', sourceId: listId);
}
