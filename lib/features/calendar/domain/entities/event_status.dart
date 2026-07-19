import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/calendar/domain/entities/event.dart';

/// An [Event]'s relationship to "now" — pure, independently testable, never
/// reads the clock itself (see [eventStatus]'s doc comment). Drives Planner/
/// Agenda's "upcoming/ongoing/past" grouping without either importing
/// [Event] directly.
enum EventStatus { upcoming, ongoing, past }

/// Classifies [event] against [now]. Semantics:
///
/// Timed event with an [Event.endAt]:
/// - upcoming: `now < startAt`
/// - ongoing: `startAt <= now < endAt`
/// - past: `now >= endAt`
///
/// Timed point event (no [Event.endAt]): no interval to be "inside", so it
/// is never [EventStatus.ongoing] — upcoming until [Event.startAt] passes,
/// then immediately past.
///
/// All-day event: compares [now]'s local calendar date against the
/// [Event.startAt]/[Event.endAt] calendar-date range (inclusive), never the
/// raw midnight timestamp — an all-day event covering today is always
/// [EventStatus.ongoing] for the entirety of today, not just at midnight.
EventStatus eventStatus(Event event, {required DateTime now}) {
  if (event.isAllDay) {
    final today = dateOnly(now);
    final start = dateOnly(event.startAt);
    final end = event.endAt == null ? start : dateOnly(event.endAt!);
    if (today.isBefore(start)) return EventStatus.upcoming;
    if (today.isAfter(end)) return EventStatus.past;
    return EventStatus.ongoing;
  }

  final end = event.endAt;
  if (end == null) {
    return now.isBefore(event.startAt)
        ? EventStatus.upcoming
        : EventStatus.past;
  }
  if (now.isBefore(event.startAt)) return EventStatus.upcoming;
  if (now.isBefore(end)) return EventStatus.ongoing;
  return EventStatus.past;
}
