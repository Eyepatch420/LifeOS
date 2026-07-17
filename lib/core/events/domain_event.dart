/// Base type for cross-feature events. Repositories emit these onto
/// [eventBusProvider] instead of writing notifications directly — the
/// NotificationEngine (and, later, analytics/achievements/widgets) consumes
/// the same stream without any feature depending on another feature's types.
///
/// Concrete events (`ReminderCreated`, `HabitCompleted`, etc.) are defined
/// by their owning feature under `features/<f>/domain/events/` and extend
/// this class — `core/events/` only owns the bus, not the event catalogue.
abstract class DomainEvent {
  const DomainEvent({required this.sourceModule, required this.sourceId});

  /// The feature that emitted this event, e.g. `'reminders'`, `'habits'`.
  /// Lets a subscriber (or a notification tap) route back without an
  /// import.
  final String sourceModule;

  /// The id of the entity the event is about, within [sourceModule].
  final String sourceId;
}
