import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_dashboard_provider.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);
  DateTime _now;

  @override
  DateTime now() => _now;

  void set(DateTime value) => _now = value;
}

void main() {
  late _FakeClock clock;

  ProviderContainer makeContainer() {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    clock = _FakeClock(DateTime(2026, 1, 1, 9));
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockManagerProvider.overrideWithValue(clock),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    return container;
  }

  test('zero sessions yields a zero-duration summary', () async {
    final container = makeContainer();
    final sub = container.listen(focusDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    final summary = await container.read(focusDashboardProvider.future);
    expect(summary.todayFocusedDuration, Duration.zero);
    expect(summary.activeSession, isNull);
    expect(summary.recentSessions, isEmpty);
  });

  test('todayFocusedDuration sums completed sessions started today', () async {
    final container = makeContainer();
    final sub = container.listen(focusDashboardProvider, (_, _) {});
    addTearDown(sub.close);
    final repository = container.read(focusRepositoryProvider);

    await repository.startSession(id: 'f1', plannedMinutes: 25);
    clock.set(clock.now().add(const Duration(minutes: 25)));
    await repository.completeSession('f1');

    await pumpEventQueue();
    final summary = container.read(focusDashboardProvider).value!;
    expect(summary.todayFocusedDuration, const Duration(minutes: 25));
    expect(summary.recentSessions, hasLength(1));
    expect(summary.recentSessions.single.id, 'f1');
  });

  test('activeSession reflects a running (uncompleted) session', () async {
    final container = makeContainer();
    final sub = container.listen(focusDashboardProvider, (_, _) {});
    addTearDown(sub.close);
    final repository = container.read(focusRepositoryProvider);

    await repository.startSession(id: 'f1', plannedMinutes: 25);

    await pumpEventQueue();
    final summary = container.read(focusDashboardProvider).value!;
    expect(summary.activeSession?.id, 'f1');
    expect(summary.activeSession?.isPaused, isFalse);
  });

  test('a session that started yesterday is not counted toward today, even if '
      'its elapsed time would otherwise be nonzero', () async {
    final container = makeContainer();
    final sub = container.listen(focusDashboardProvider, (_, _) {});
    addTearDown(sub.close);
    final repository = container.read(focusRepositoryProvider);

    await repository.startSession(id: 'f1', plannedMinutes: 25);
    clock.set(clock.now().add(const Duration(minutes: 25)));
    await repository.completeSession('f1');

    // Advance to the next day — "today" for the dashboard is now the 2nd.
    clock.set(DateTime(2026, 1, 2, 9));

    await pumpEventQueue();
    final summary = container.read(focusDashboardProvider).value!;
    expect(summary.todayFocusedDuration, Duration.zero);
  });

  test('a session crossing midnight attributes its full duration to its '
      'startedAt date, never double-counted on both days', () async {
    final container = makeContainer();
    final sub = container.listen(focusDashboardProvider, (_, _) {});
    addTearDown(sub.close);
    final repository = container.read(focusRepositoryProvider);
    final db = container.read(databaseProvider);

    // Starts 23:50 on Jan 1.
    clock.set(DateTime(2026, 1, 1, 23, 50));
    await repository.startSession(id: 'f1', plannedMinutes: 30);
    // Completes 00:20 on Jan 2.
    clock.set(DateTime(2026, 1, 2, 0, 20));
    await repository.completeSession('f1');

    await pumpEventQueue();
    final onStartDay = container.read(focusDashboardProvider).value!;
    // The dashboard's "today" is wherever the clock currently is (Jan 2)
    // — the full 30 minutes is attributed to Jan 1 (startedAt's date),
    // so "today" (Jan 2) shows zero from this session.
    expect(onStartDay.todayFocusedDuration, Duration.zero);

    // A second container over the SAME database, with its clock fixed to
    // Jan 1 (simulating "today" being the 1st) shows the full, un-split
    // 30 minutes — proving it's credited entirely to the start date, not
    // split 10/20 across the boundary.
    final jan1Clock = _FakeClock(DateTime(2026, 1, 1, 12));
    final jan1Container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockManagerProvider.overrideWithValue(jan1Clock),
      ],
    );
    addTearDown(jan1Container.dispose);
    final jan1Sub = jan1Container.listen(focusDashboardProvider, (_, _) {});
    addTearDown(jan1Sub.close);
    final onOriginalDay = await jan1Container.read(
      focusDashboardProvider.future,
    );
    expect(onOriginalDay.todayFocusedDuration, const Duration(minutes: 30));
  });
}
