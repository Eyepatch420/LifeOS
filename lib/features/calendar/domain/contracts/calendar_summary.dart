import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_summary.freezed.dart';

/// One upcoming event entry in the Calendar feature's dashboard summary —
/// Home imports this and [CalendarSummary] only, never `Event`/
/// `EventsRepository` directly (see docs/architecture_principles.md's
/// Architecture Constraint 1).
@freezed
abstract class UpcomingEventSummary with _$UpcomingEventSummary {
  const factory UpcomingEventSummary({
    required String id,
    required String title,
    required DateTime startAt,
    required bool isAllDay,
  }) = _UpcomingEventSummary;
}

/// The Calendar feature's full dashboard contribution.
@freezed
abstract class CalendarSummary with _$CalendarSummary {
  const factory CalendarSummary({
    required List<UpcomingEventSummary> upcoming,
    required int todayCount,
  }) = _CalendarSummary;
}
