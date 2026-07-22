import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [SleepRepository] when a new sleep record is logged.
class SleepLogged extends DomainEvent {
  const SleepLogged({required String entryId})
    : super(sourceModule: 'sleep', sourceId: entryId);
}

/// Emitted when an existing sleep record's bedtime/wake time/quality is
/// edited.
class SleepUpdated extends DomainEvent {
  const SleepUpdated({required String entryId})
    : super(sourceModule: 'sleep', sourceId: entryId);
}

/// Emitted when a sleep record is deleted.
class SleepDeleted extends DomainEvent {
  const SleepDeleted({required String entryId})
    : super(sourceModule: 'sleep', sourceId: entryId);
}
