import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';

part 'focus_dashboard_summary.freezed.dart';

/// Focus's dashboard contract — the ONLY thing another feature (Home) is
/// allowed to `ref.watch()`. Mirrors `RemindersSummary`'s role exactly:
/// Home never sees [FocusSession] or `FocusRepository`.
@freezed
abstract class FocusDashboardSummary with _$FocusDashboardSummary {
  const factory FocusDashboardSummary({
    required Duration todayFocusedDuration,
    required List<FocusSessionSummary> recentSessions,
    FocusSessionSummary? activeSession,
  }) = _FocusDashboardSummary;
}

/// One row of Focus history, or the shape of the currently active session.
/// Deliberately doesn't leak [FocusSessionStatus]/timestamps beyond what a
/// summary consumer needs — [elapsedMinutes]/[plannedMinutes] are plain
/// ints so `Home`/`Search` never need to import [FocusSession] to render
/// something.
@freezed
abstract class FocusSessionSummary with _$FocusSessionSummary {
  const factory FocusSessionSummary({
    required String id,
    required int plannedMinutes,
    required int elapsedMinutes,
    required bool isPaused,
    required DateTime startedAt,
    required FocusSessionStatus status,
    DateTime? endedAt,
  }) = _FocusSessionSummary;
}
