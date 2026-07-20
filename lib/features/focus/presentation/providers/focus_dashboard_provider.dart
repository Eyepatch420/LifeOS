import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/focus/data/repositories/focus_repository.dart';
import 'package:lifeos/features/focus/domain/contracts/focus_dashboard_summary.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';

final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  return FocusRepository(
    ref.watch(databaseProvider).focusSessionsDao,
    ref.watch(eventBusProvider),
    ref.watch(clockManagerProvider),
  );
});

/// The Focus feature's own dashboard provider — the only thing another
/// feature (Home) is allowed to `ref.watch()`. Home never sees
/// [FocusSession] or [FocusRepository] (Golden Rule).
///
/// **Midnight attribution rule**: a session's entire elapsed duration is
/// credited to the calendar date it *started* on, never split
/// proportionally across a midnight boundary it happens to cross. E.g. a
/// 23:50->00:20 session counts its full 30 minutes toward the day it
/// started, and 0 toward the next day. This is the one explicit,
/// consistent rule this dashboard uses — chosen over proportional
/// attribution because the elapsed-time split would depend on
/// pause/resume history mid-session (which pause happened before/after
/// midnight), which the current schema can reconstruct but at a
/// disproportionate cost for a rare edge case; simple `startedAt`-day
/// attribution can never double count or drop time, which is the actual
/// invariant that matters here.
final focusDashboardProvider = StreamProvider<FocusDashboardSummary>((ref) {
  final repository = ref.watch(focusRepositoryProvider);
  final clock = ref.watch(clockManagerProvider);

  return repository.watchAll().map((sessions) {
    final now = clock.now();
    final today = DateTime(now.year, now.month, now.day);

    var todayTotal = Duration.zero;
    FocusSession? active;
    final recent = <FocusSession>[];

    for (final session in sessions) {
      final startedDay = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );
      if (startedDay == today) {
        todayTotal += session.elapsedAt(now);
      }
      if (session.isActive) active = session;
      if (session.status == FocusSessionStatus.completed) recent.add(session);
    }

    recent.sort((a, b) => b.startedAt.compareTo(a.startedAt));

    return FocusDashboardSummary(
      todayFocusedDuration: todayTotal,
      activeSession: active == null ? null : _toSummary(active, now),
      recentSessions: [for (final s in recent.take(10)) _toSummary(s, now)],
    );
  });
});

FocusSessionSummary _toSummary(FocusSession session, DateTime now) {
  return FocusSessionSummary(
    id: session.id,
    plannedMinutes: session.plannedMinutes,
    elapsedMinutes: session.elapsedAt(now).inMinutes,
    isPaused: session.status == FocusSessionStatus.paused,
    startedAt: session.startedAt,
    status: session.status,
    endedAt: session.endedAt,
  );
}
