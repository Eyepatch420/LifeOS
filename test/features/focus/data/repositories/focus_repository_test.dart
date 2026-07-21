import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/focus/data/repositories/focus_repository.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/domain/events/focus_events.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  void advance(Duration by) => _now = _now.add(by);
  void set(DateTime value) => _now = value;
}

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late _FakeClock clock;
  late FocusRepository repository;
  final events = <DomainEvent>[];

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    events.clear();
    eventBus.events.listen(events.add);
    clock = _FakeClock(DateTime(2026, 1, 1, 9));
    repository = FocusRepository(db.focusSessionsDao, eventBus, clock);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('watchActiveSession is null before any session starts', () async {
    expect(await repository.watchActiveSession().first, isNull);
  });

  test(
    'startSession creates a running session and emits FocusSessionStarted',
    () async {
      final session = await repository.startSession(
        id: 'f1',
        plannedMinutes: 25,
      );

      expect(session.status, FocusSessionStatus.running);
      expect(session.startedAt, clock.now());
      expect(session.plannedMinutes, 25);

      final active = await repository.watchActiveSession().first;
      expect(active?.id, 'f1');

      await pumpEventQueue();
      expect(events.whereType<FocusSessionStarted>(), hasLength(1));
      expect(
        events.whereType<FocusSessionStarted>().single.projectedEndAt,
        clock.now().add(const Duration(minutes: 25)),
      );
    },
  );

  test('startSession rejects a non-positive duration', () async {
    expect(
      () => repository.startSession(id: 'f1', plannedMinutes: 0),
      throwsArgumentError,
    );
  });

  test('starting a second session while one is active throws '
      'FocusSessionAlreadyActiveException', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);

    expect(
      () => repository.startSession(id: 'f2', plannedMinutes: 25),
      throwsA(isA<FocusSessionAlreadyActiveException>()),
    );
  });

  test('pauseSession stops elapsed time from accruing further', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);
    clock.advance(const Duration(minutes: 10));
    await repository.pauseSession('f1');

    var active = await repository.watchActiveSession().first;
    expect(active!.status, FocusSessionStatus.paused);
    expect(active.elapsedAt(clock.now()), const Duration(minutes: 10));

    // Time passing while paused must not count.
    clock.advance(const Duration(minutes: 5));
    active = await repository.watchActiveSession().first;
    expect(active!.elapsedAt(clock.now()), const Duration(minutes: 10));

    await pumpEventQueue();
    expect(events.whereType<FocusSessionPaused>(), hasLength(1));
  });

  test('resumeSession excludes the paused interval from elapsed time going '
      'forward', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);
    clock.advance(const Duration(minutes: 10));
    await repository.pauseSession('f1');
    clock.advance(const Duration(minutes: 5));
    await repository.resumeSession('f1');
    clock.advance(const Duration(minutes: 5));

    final active = await repository.watchActiveSession().first;
    expect(active!.status, FocusSessionStatus.running);
    // 10 min pre-pause + 5 min post-resume = 15, the 5 min paused
    // interval excluded.
    expect(active.elapsedAt(clock.now()), const Duration(minutes: 15));

    await pumpEventQueue();
    expect(events.whereType<FocusSessionResumed>(), hasLength(1));
    // Projected end pushes back by the paused duration.
    final resumedEvent = events.whereType<FocusSessionResumed>().single;
    expect(
      resumedEvent.projectedEndAt,
      DateTime(
        2026,
        1,
        1,
        9,
      ).add(const Duration(minutes: 25)).add(const Duration(minutes: 5)),
    );
  });

  test('resumeSession is a no-op if the session is not paused', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);
    await repository.resumeSession('f1');

    await pumpEventQueue();
    expect(events.whereType<FocusSessionResumed>(), isEmpty);
  });

  test(
    'completeSession ends the session and clears watchActiveSession',
    () async {
      await repository.startSession(id: 'f1', plannedMinutes: 25);
      clock.advance(const Duration(minutes: 12));
      await repository.completeSession('f1');

      expect(await repository.watchActiveSession().first, isNull);
      final all = await repository.watchAll().first;
      expect(all.single.status, FocusSessionStatus.completed);
      expect(all.single.endedAt, clock.now());

      await pumpEventQueue();
      expect(events.whereType<FocusSessionCompleted>(), hasLength(1));
    },
  );

  test('completeSession is idempotent against a second call', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);
    await repository.completeSession('f1');
    await repository.completeSession('f1');

    await pumpEventQueue();
    expect(events.whereType<FocusSessionCompleted>(), hasLength(1));
  });

  test('cancelSession ends the session as cancelled', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);
    await repository.cancelSession('f1');

    final all = await repository.watchAll().first;
    expect(all.single.status, FocusSessionStatus.cancelled);
    expect(await repository.watchActiveSession().first, isNull);

    await pumpEventQueue();
    expect(events.whereType<FocusSessionCancelled>(), hasLength(1));
  });

  test(
    'cancelSession is idempotent against an already-completed session',
    () async {
      await repository.startSession(id: 'f1', plannedMinutes: 25);
      await repository.completeSession('f1');
      await repository.cancelSession('f1');

      await pumpEventQueue();
      expect(events.whereType<FocusSessionCancelled>(), isEmpty);
    },
  );

  test('reconcileActiveSession completes a running session whose clock has '
      'passed its planned end, with no explicit user action', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);
    clock.advance(const Duration(minutes: 26));

    await repository.reconcileActiveSession();

    expect(await repository.watchActiveSession().first, isNull);
    final all = await repository.watchAll().first;
    expect(all.single.status, FocusSessionStatus.completed);
  });

  test('reconcileActiveSession does nothing to a running session still within '
      'its planned duration', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);
    clock.advance(const Duration(minutes: 10));

    await repository.reconcileActiveSession();

    final active = await repository.watchActiveSession().first;
    expect(active?.status, FocusSessionStatus.running);
  });

  test('reconcileActiveSession does not touch a paused session', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);
    await repository.pauseSession('f1');
    clock.advance(const Duration(minutes: 30));

    await repository.reconcileActiveSession();

    final active = await repository.watchActiveSession().first;
    expect(active?.status, FocusSessionStatus.paused);
  });

  test(
    'watchSessionsForDate only returns sessions started on that date',
    () async {
      await repository.startSession(id: 'f1', plannedMinutes: 25);
      await repository.completeSession('f1');

      clock.set(DateTime(2026, 1, 2, 9));
      await repository.startSession(id: 'f2', plannedMinutes: 25);
      await repository.completeSession('f2');

      final day1 = await repository
          .watchSessionsForDate(DateTime(2026, 1, 1))
          .first;
      expect(day1.map((s) => s.id), ['f1']);

      final day2 = await repository
          .watchSessionsForDate(DateTime(2026, 1, 2))
          .first;
      expect(day2.map((s) => s.id), ['f2']);
    },
  );

  test('watchById returns the session by id, and null once no matching row '
      'exists', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);

    final found = await repository.watchById('f1').first;
    expect(found?.id, 'f1');

    final missing = await repository.watchById('does-not-exist').first;
    expect(missing, isNull);
  });

  test('reconcileActiveSession called twice in a row for the same naturally '
      'elapsed session only completes it once (idempotent against repeated '
      'ticker-driven calls)', () async {
    await repository.startSession(id: 'f1', plannedMinutes: 25);
    clock.advance(const Duration(minutes: 26));

    await repository.reconcileActiveSession();
    await repository.reconcileActiveSession();

    await pumpEventQueue();
    expect(events.whereType<FocusSessionCompleted>(), hasLength(1));
    final all = await repository.watchAll().first;
    expect(all, hasLength(1));
    expect(all.single.status, FocusSessionStatus.completed);
  });

  group('reconcileNotificationsOnStartup', () {
    test('a still-running session emits FocusSessionResumed with the current '
        'projected end time, so the notification contributor re-shows the '
        'ongoing notification and reschedules the completion alarm', () async {
      await repository.startSession(id: 'f1', plannedMinutes: 25);
      events.clear();
      clock.advance(const Duration(minutes: 10));

      await repository.reconcileNotificationsOnStartup();

      await pumpEventQueue();
      expect(events.whereType<FocusSessionResumed>(), hasLength(1));
      expect(
        events.whereType<FocusSessionResumed>().single.projectedEndAt,
        DateTime(2026, 1, 1, 9).add(const Duration(minutes: 25)),
      );
      final active = await repository.watchActiveSession().first;
      expect(active?.status, FocusSessionStatus.running);
    });

    test('a session that has naturally expired while the app was dead is '
        'completed instead of having its notification restored', () async {
      await repository.startSession(id: 'f1', plannedMinutes: 25);
      events.clear();
      clock.advance(const Duration(minutes: 26));

      await repository.reconcileNotificationsOnStartup();

      await pumpEventQueue();
      expect(events.whereType<FocusSessionResumed>(), isEmpty);
      expect(events.whereType<FocusSessionCompleted>(), hasLength(1));
      expect(await repository.watchActiveSession().first, isNull);
    });

    test('a paused session emits nothing — its notification is intentionally '
        'absent', () async {
      await repository.startSession(id: 'f1', plannedMinutes: 25);
      await repository.pauseSession('f1');
      await pumpEventQueue();
      events.clear();

      await repository.reconcileNotificationsOnStartup();

      await pumpEventQueue();
      expect(events, isEmpty);
    });

    test('a completed session emits nothing', () async {
      await repository.startSession(id: 'f1', plannedMinutes: 25);
      await repository.completeSession('f1');
      await pumpEventQueue();
      events.clear();

      await repository.reconcileNotificationsOnStartup();

      await pumpEventQueue();
      expect(events, isEmpty);
    });

    test('a cancelled session emits nothing', () async {
      await repository.startSession(id: 'f1', plannedMinutes: 25);
      await repository.cancelSession('f1');
      await pumpEventQueue();
      events.clear();

      await repository.reconcileNotificationsOnStartup();

      await pumpEventQueue();
      expect(events, isEmpty);
    });

    test('no active session at all emits nothing', () async {
      await repository.reconcileNotificationsOnStartup();

      await pumpEventQueue();
      expect(events, isEmpty);
    });
  });
}
