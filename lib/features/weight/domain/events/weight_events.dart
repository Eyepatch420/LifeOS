import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [WeightRepository] when a new weight measurement is logged.
class WeightLogged extends DomainEvent {
  const WeightLogged({required String entryId})
    : super(sourceModule: 'weight', sourceId: entryId);
}

/// Emitted when an existing weight entry is edited.
class WeightUpdated extends DomainEvent {
  const WeightUpdated({required String entryId})
    : super(sourceModule: 'weight', sourceId: entryId);
}

/// Emitted when a weight entry is deleted.
class WeightDeleted extends DomainEvent {
  const WeightDeleted({required String entryId})
    : super(sourceModule: 'weight', sourceId: entryId);
}
