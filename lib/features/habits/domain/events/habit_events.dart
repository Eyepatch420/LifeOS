import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [HabitsRepository] on habit creation. Carries `title` (not
/// just the id) — see `ReminderCreated`'s doc comment for why: lets
/// [HabitsNotificationContributor] build a notification without an async
/// repository re-read.
class HabitCreated extends DomainEvent {
  const HabitCreated({required String habitId, required this.title})
    : super(sourceModule: 'habits', sourceId: habitId);

  final String title;
}

/// Emitted when a habit's title/schedule changes.
class HabitUpdated extends DomainEvent {
  const HabitUpdated({required String habitId, required this.title})
    : super(sourceModule: 'habits', sourceId: habitId);

  final String title;
}

/// Emitted when today's occurrence of a habit is marked complete.
class HabitCompleted extends DomainEvent {
  const HabitCompleted({required String habitId, required this.localDate})
    : super(sourceModule: 'habits', sourceId: habitId);

  /// `yyyy-MM-dd`, matching `HabitCompletions.localDate`.
  final String localDate;
}

/// Emitted when a habit is archived (the feature's soft-delete).
class HabitArchived extends DomainEvent {
  const HabitArchived({required String habitId})
    : super(sourceModule: 'habits', sourceId: habitId);
}
