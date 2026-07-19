import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_session.freezed.dart';

enum FocusSessionStatus { running, paused, completed, cancelled }

enum FocusSessionKind { focus, breakSession }

/// A persisted Focus session. The domain entity, distinct from the Drift
/// `FocusSession` row shape — [FocusRepository] is the only place that maps
/// between them (same convention as `Reminder`/`RemindersRepository`).
///
/// Timestamps are the sole source of truth for elapsed/remaining time — see
/// [elapsedAt]. Nothing here depends on an in-memory countdown having
/// actually ticked; a UI timer just calls [elapsedAt]/[remainingAt] with
/// the current clock value once a second for display.
@freezed
abstract class FocusSession with _$FocusSession {
  const factory FocusSession({
    required String id,
    required DateTime startedAt,
    required int plannedMinutes,
    required FocusSessionKind kind,
    required FocusSessionStatus status,
    DateTime? endedAt,
    DateTime? pausedAt,
    @Default(0) int accumulatedPausedMs,
  }) = _FocusSession;

  const FocusSession._();

  Duration get plannedDuration => Duration(minutes: plannedMinutes);

  bool get isActive =>
      status == FocusSessionStatus.running ||
      status == FocusSessionStatus.paused;

  /// Total time actually spent focused as of [now] — `now - startedAt`
  /// minus every paused interval (completed pauses via
  /// [accumulatedPausedMs], plus the currently-open pause if [status] is
  /// [FocusSessionStatus.paused]). Clamped to `[0, plannedDuration]` so a
  /// clock that's run past the planned end doesn't report an elapsed time
  /// longer than what a completed session would ultimately record.
  Duration elapsedAt(DateTime now) {
    if (status == FocusSessionStatus.completed ||
        status == FocusSessionStatus.cancelled) {
      final end = endedAt ?? now;
      return _elapsedBetween(end);
    }
    final reference = status == FocusSessionStatus.paused
        ? (pausedAt ?? now)
        : now;
    return _elapsedBetween(reference);
  }

  Duration _elapsedBetween(DateTime reference) {
    final raw =
        reference.difference(startedAt) -
        Duration(milliseconds: accumulatedPausedMs);
    if (raw <= Duration.zero) return Duration.zero;
    if (raw >= plannedDuration) return plannedDuration;
    return raw;
  }

  Duration remainingAt(DateTime now) => plannedDuration - elapsedAt(now);

  /// `0.0`-`1.0`, derived purely from [elapsedAt] — never persisted
  /// separately, so nothing can let progress and elapsed time disagree.
  double progressAt(DateTime now) {
    if (plannedDuration.inMilliseconds == 0) return 0;
    return (elapsedAt(now).inMilliseconds / plannedDuration.inMilliseconds)
        .clamp(0.0, 1.0);
  }

  /// The wall-clock instant this session would naturally complete at,
  /// assuming no further pauses — `startedAt + plannedDuration +
  /// accumulatedPausedMs`. Used both to schedule the completion
  /// notification and to reconcile a session that's been left running past
  /// its end while the app was closed. Only meaningful while
  /// [FocusSessionStatus.running] — a paused session has no fixed
  /// projected end until it resumes and this is recomputed against the
  /// then-current [accumulatedPausedMs].
  DateTime projectedEndAt() {
    final pauseOffset = Duration(milliseconds: accumulatedPausedMs);
    return startedAt.add(plannedDuration).add(pauseOffset);
  }

  bool hasNaturallyCompletedAt(DateTime now) =>
      status == FocusSessionStatus.running &&
      now.isAfter(projectedEndAt()) &&
      !now.isBefore(projectedEndAt());
}
