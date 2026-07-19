import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [FocusRepository] when a session starts (or resumes from
/// pause). Carries [projectedEndAt] so [FocusNotificationContributor] can
/// build a [ScheduleNotification] synchronously without an async repository
/// re-read — mirrors [ReminderCreated]'s rationale exactly.
class FocusSessionStarted extends DomainEvent {
  const FocusSessionStarted({
    required String sessionId,
    required this.projectedEndAt,
  }) : super(sourceModule: 'focus', sourceId: sessionId);

  final DateTime projectedEndAt;
}

/// Emitted on resume — same shape/handling as [FocusSessionStarted]
/// (reschedule the completion notification at the newly-projected end
/// time), kept as a distinct type so a future contributor/analytics
/// consumer can distinguish an initial start from a resume without
/// inspecting session state.
class FocusSessionResumed extends DomainEvent {
  const FocusSessionResumed({
    required String sessionId,
    required this.projectedEndAt,
  }) : super(sourceModule: 'focus', sourceId: sessionId);

  final DateTime projectedEndAt;
}

/// Emitted on pause. [FocusNotificationContributor] cancels the pending
/// completion notification — a paused session must never fire early.
class FocusSessionPaused extends DomainEvent {
  const FocusSessionPaused({required String sessionId})
    : super(sourceModule: 'focus', sourceId: sessionId);
}

/// Emitted when a session completes (naturally or manually ended early with
/// time remaining). Cancels any still-pending completion notification —
/// the natural-completion path fires the OS notification itself via the
/// alarm that was scheduled at start/resume, not via this event.
class FocusSessionCompleted extends DomainEvent {
  const FocusSessionCompleted({required String sessionId})
    : super(sourceModule: 'focus', sourceId: sessionId);
}

/// Emitted when a session is cancelled before completion. Same notification
/// handling as [FocusSessionCompleted].
class FocusSessionCancelled extends DomainEvent {
  const FocusSessionCancelled({required String sessionId})
    : super(sourceModule: 'focus', sourceId: sessionId);
}
