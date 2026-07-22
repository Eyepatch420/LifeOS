import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [HydrationRepository] when a new water intake is logged.
class HydrationLogged extends DomainEvent {
  const HydrationLogged({required String entryId})
    : super(sourceModule: 'hydration', sourceId: entryId);
}

/// Emitted when an existing hydration entry's amount is edited.
class HydrationUpdated extends DomainEvent {
  const HydrationUpdated({required String entryId})
    : super(sourceModule: 'hydration', sourceId: entryId);
}

/// Emitted when a hydration entry is deleted.
class HydrationDeleted extends DomainEvent {
  const HydrationDeleted({required String entryId})
    : super(sourceModule: 'hydration', sourceId: entryId);
}
