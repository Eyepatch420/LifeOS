import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/focus_sessions_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/domain/events/focus_events.dart';

/// Thrown when a caller tries to start a session while another is already
/// active (running or paused) — [FocusRepository] enforces "only one active
/// session" itself rather than leaving it to the UI to check first, so the
/// invariant holds even against a race (e.g. a double-tapped Start button).
class FocusSessionAlreadyActiveException implements Exception {
  const FocusSessionAlreadyActiveException();

  @override
  String toString() =>
      'A Focus session is already active; end it before starting another.';
}

/// The single owner of Focus persistence — every mutation/query for Focus
/// sessions goes through here, wrapping [FocusSessionsDao] and mapping
/// Drift rows to the feature's own [FocusSession] entity. No other feature
/// imports this class or [FocusSessionsDao] directly (Golden Rule).
///
/// Emits [FocusSessionStarted]/[FocusSessionResumed]/[FocusSessionPaused]/
/// [FocusSessionCompleted]/[FocusSessionCancelled] onto the shared
/// [EventBus] for every lifecycle transition — never calls
/// `NotificationScheduler` directly (Architecture Constraint 5);
/// `FocusNotificationContributor` is the only consumer that turns these
/// into real scheduling calls.
///
/// All "now" values come from [ClockManager], not `DateTime.now()`
/// directly, so tests can drive the timeline with a fake clock.
class FocusRepository {
  FocusRepository(this._dao, this._eventBus, this._clock);

  final FocusSessionsDao _dao;
  final EventBus _eventBus;
  final ClockManager _clock;

  Stream<List<FocusSession>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  Stream<FocusSession?> watchActiveSession() {
    return _dao.watchActive().map((row) => row == null ? null : _toEntity(row));
  }

  /// A single session by id, live — used by the session-details screen so
  /// it always reflects the authoritative persisted record (survives
  /// process recreation/deep navigation) rather than a value passed through
  /// navigation.
  Stream<FocusSession?> watchById(String id) {
    return _dao.watchById(id).map((row) => row == null ? null : _toEntity(row));
  }

  Stream<List<FocusSession>> watchSessionsForDate(DateTime date) {
    return watchAll().map(
      (sessions) => [
        for (final s in sessions)
          if (_isOnDate(s.startedAt, date)) s,
      ],
    );
  }

  bool _isOnDate(DateTime dt, DateTime date) =>
      dt.year == date.year && dt.month == date.month && dt.day == date.day;

  /// Starts a new session. Throws [FocusSessionAlreadyActiveException] if
  /// one is already running/paused — callers should check
  /// [watchActiveSession] first for UI purposes, but this is the actual
  /// enforcement point.
  Future<FocusSession> startSession({
    required String id,
    required int plannedMinutes,
    FocusSessionKind kind = FocusSessionKind.focus,
  }) async {
    if (plannedMinutes <= 0) {
      throw ArgumentError.value(
        plannedMinutes,
        'plannedMinutes',
        'must be greater than zero',
      );
    }
    final existing = await _dao.watchActive().first;
    if (existing != null) throw const FocusSessionAlreadyActiveException();

    final now = _clock.now();
    await _dao.upsert(
      db.FocusSessionsCompanion.insert(
        id: id,
        startedAt: now,
        plannedMinutes: plannedMinutes,
        kind: _kindToStorage(kind),
        status: const Value('running'),
      ),
    );
    final session = FocusSession(
      id: id,
      startedAt: now,
      plannedMinutes: plannedMinutes,
      kind: kind,
      status: FocusSessionStatus.running,
    );
    _eventBus.emit(
      FocusSessionStarted(
        sessionId: id,
        projectedEndAt: session.projectedEndAt(),
      ),
    );
    return session;
  }

  Future<void> pauseSession(String id) async {
    final row = await _dao.watchActive().first;
    if (row == null || row.id != id || row.status != 'running') return;

    await _dao.updateFields(
      id,
      db.FocusSessionsCompanion(
        status: const Value('paused'),
        pausedAt: Value(_clock.now()),
      ),
    );
    _eventBus.emit(FocusSessionPaused(sessionId: id));
  }

  Future<void> resumeSession(String id) async {
    final row = await _dao.watchActive().first;
    if (row == null || row.id != id || row.status != 'paused') return;

    final pausedAt = row.pausedAt;
    final now = _clock.now();
    final addedPauseMs = pausedAt == null
        ? 0
        : now.difference(pausedAt).inMilliseconds;

    await _dao.updateFields(
      id,
      db.FocusSessionsCompanion(
        status: const Value('running'),
        pausedAt: const Value(null),
        accumulatedPausedMs: Value(row.accumulatedPausedMs + addedPauseMs),
      ),
    );
    final resumed = _toEntity(row).copyWith(
      status: FocusSessionStatus.running,
      pausedAt: null,
      accumulatedPausedMs: row.accumulatedPausedMs + addedPauseMs,
    );
    _eventBus.emit(
      FocusSessionResumed(
        sessionId: id,
        projectedEndAt: resumed.projectedEndAt(),
      ),
    );
  }

  /// Marks the session completed as of now. Idempotent against a session
  /// that's already completed/cancelled — a second call (e.g. a stale
  /// natural-completion reconciliation racing a manual "End Focus" tap) is
  /// a safe no-op rather than a double-emit.
  Future<void> completeSession(String id) async {
    final row = await _dao.getById(id);
    if (row == null) return;
    if (row.status == 'completed' || row.status == 'cancelled') return;

    await _dao.updateFields(
      id,
      db.FocusSessionsCompanion(
        status: const Value('completed'),
        endedAt: Value(_clock.now()),
      ),
    );
    _eventBus.emit(FocusSessionCompleted(sessionId: id));
  }

  /// Cancels the session before natural completion. Idempotent for the same
  /// reason as [completeSession].
  Future<void> cancelSession(String id) async {
    final row = await _dao.getById(id);
    if (row == null) return;
    if (row.status == 'completed' || row.status == 'cancelled') return;

    await _dao.updateFields(
      id,
      db.FocusSessionsCompanion(
        status: const Value('cancelled'),
        endedAt: Value(_clock.now()),
      ),
    );
    _eventBus.emit(FocusSessionCancelled(sessionId: id));
  }

  /// Reconciles an active session against the current clock: if it's
  /// [FocusSessionStatus.running] and past its [FocusSession.projectedEndAt],
  /// completes it. Called on app resume/controller (re)build rather than
  /// relying on a background timer callback having fired while the process
  /// was dead — see this feature's module doc for why (timestamp
  /// reconciliation is robust to process death; a missed callback is not).
  /// No-op if there's no active session or it hasn't reached its end yet.
  Future<void> reconcileActiveSession() async {
    final row = await _dao.watchActive().first;
    if (row == null || row.status != 'running') return;
    final session = _toEntity(row);
    final now = _clock.now();
    if (session.hasNaturallyCompletedAt(now)) {
      await completeSession(row.id);
    }
  }

  FocusSession _toEntity(db.FocusSession row) => FocusSession(
    id: row.id,
    startedAt: row.startedAt,
    plannedMinutes: row.plannedMinutes,
    kind: _kindFromStorage(row.kind),
    status: _statusFromStorage(row.status),
    endedAt: row.endedAt,
    pausedAt: row.pausedAt,
    accumulatedPausedMs: row.accumulatedPausedMs,
  );

  String _kindToStorage(FocusSessionKind kind) => switch (kind) {
    FocusSessionKind.focus => 'focus',
    FocusSessionKind.breakSession => 'break',
  };

  FocusSessionKind _kindFromStorage(String value) => switch (value) {
    'break' => FocusSessionKind.breakSession,
    _ => FocusSessionKind.focus,
  };

  FocusSessionStatus _statusFromStorage(String value) => switch (value) {
    'paused' => FocusSessionStatus.paused,
    'completed' => FocusSessionStatus.completed,
    'cancelled' => FocusSessionStatus.cancelled,
    _ => FocusSessionStatus.running,
  };
}
