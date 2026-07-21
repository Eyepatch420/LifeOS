import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [MoodRepository] when a new mood entry is logged.
class MoodLogged extends DomainEvent {
  const MoodLogged({required String entryId})
    : super(sourceModule: 'mood', sourceId: entryId);
}

/// Emitted when an existing mood entry's level/note is edited.
class MoodUpdated extends DomainEvent {
  const MoodUpdated({required String entryId})
    : super(sourceModule: 'mood', sourceId: entryId);
}

/// Emitted when a mood entry is deleted.
class MoodDeleted extends DomainEvent {
  const MoodDeleted({required String entryId})
    : super(sourceModule: 'mood', sourceId: entryId);
}
