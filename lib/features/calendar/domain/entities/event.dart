import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

/// A persisted calendar event. This is the feature's own domain entity,
/// distinct from the Drift `Event` row shape — [EventsRepository] is the
/// only place that maps between them, mirroring `Reminder`/`Habit`'s split.
///
/// [endAt] is nullable: a null [endAt] on a timed event represents a
/// point-in-time event (e.g. "Call at 3pm") with no duration — [isOngoing]
/// is never true for one, since there's no interval to be inside; it is
/// simply upcoming until [startAt] passes, then immediately past. For an
/// all-day event, [startAt]/[endAt] are calendar-date midnights (local
/// time, [dateOnly]-normalized by [EventsRepository]) — [endAt] absent
/// means a single-day all-day event.
@freezed
abstract class Event with _$Event {
  const factory Event({
    required String id,
    required String title,
    required DateTime startAt,
    required bool isAllDay,
    required DateTime createdAt,
    String? description,
    DateTime? endAt,
    DateTime? archivedAt,
  }) = _Event;
}

extension EventActive on Event {
  bool get isActive => archivedAt == null;
}
