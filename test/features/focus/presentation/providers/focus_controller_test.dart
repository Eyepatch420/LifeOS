import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_controller.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);
  DateTime _now;

  @override
  DateTime now() => _now;

  void advance(Duration by) => _now = _now.add(by);
}

void main() {
  late AppDatabase db;
  late _FakeClock clock;

  ProviderContainer makeContainer() {
    db = AppDatabase.forTesting(
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

  test('no active session initially', () async {
    final container = makeContainer();
    final value = await container.read(focusControllerProvider.future);
    expect(value, isNull);
  });

  test(
    'start creates a running session reflected in controller state',
    () async {
      final container = makeContainer();
      await container.read(focusControllerProvider.future);

      await container
          .read(focusControllerProvider.notifier)
          .start(id: 'f1', plannedMinutes: 25);

      final session = container.read(focusControllerProvider).value;
      expect(session, isNotNull);
      expect(session!.status, FocusSessionStatus.running);
    },
  );

  test('pause then resume round-trips status correctly', () async {
    final container = makeContainer();
    await container.read(focusControllerProvider.future);
    final notifier = container.read(focusControllerProvider.notifier);

    await notifier.start(id: 'f1', plannedMinutes: 25);
    clock.advance(const Duration(minutes: 5));
    await notifier.pause();
    expect(
      container.read(focusControllerProvider).value!.status,
      FocusSessionStatus.paused,
    );

    await notifier.resume();
    expect(
      container.read(focusControllerProvider).value!.status,
      FocusSessionStatus.running,
    );
  });

  test('complete clears the active session', () async {
    final container = makeContainer();
    await container.read(focusControllerProvider.future);
    final notifier = container.read(focusControllerProvider.notifier);

    await notifier.start(id: 'f1', plannedMinutes: 25);
    await notifier.complete();

    expect(container.read(focusControllerProvider).value, isNull);
  });

  test('cancel clears the active session', () async {
    final container = makeContainer();
    await container.read(focusControllerProvider.future);
    final notifier = container.read(focusControllerProvider.notifier);

    await notifier.start(id: 'f1', plannedMinutes: 25);
    await notifier.cancel();

    expect(container.read(focusControllerProvider).value, isNull);
  });

  test(
    'a fresh ProviderContainer (process/provider recreation) reconstructs '
    'the active session from persistence with correct elapsed time',
    () async {
      final firstContainer = makeContainer();
      await firstContainer.read(focusControllerProvider.future);
      await firstContainer
          .read(focusControllerProvider.notifier)
          .start(id: 'f1', plannedMinutes: 25);
      clock.advance(const Duration(minutes: 10));

      // Simulate process death/recreation: a brand new container over the
      // SAME underlying database (not a fresh in-memory one), the way a
      // real app relaunch would reopen the same persisted file.
      final secondContainer = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockManagerProvider.overrideWithValue(clock),
        ],
      );
      addTearDown(secondContainer.dispose);

      final restored = await secondContainer.read(
        focusControllerProvider.future,
      );
      expect(restored, isNotNull);
      expect(restored!.id, 'f1');
      expect(restored.status, FocusSessionStatus.running);
      expect(restored.elapsedAt(clock.now()), const Duration(minutes: 10));
    },
  );

  test('build() reconciles a session left running past its planned end while '
      'the app was closed, completing it instead of leaving it running '
      'forever', () async {
    final firstContainer = makeContainer();
    await firstContainer.read(focusControllerProvider.future);
    await firstContainer
        .read(focusControllerProvider.notifier)
        .start(id: 'f1', plannedMinutes: 25);

    // Advance the clock well past the planned end — as if the app was
    // closed for 2 hours.
    clock.advance(const Duration(hours: 2));

    final secondContainer = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockManagerProvider.overrideWithValue(clock),
      ],
    );
    addTearDown(secondContainer.dispose);

    final restored = await secondContainer.read(focusControllerProvider.future);
    expect(restored, isNull);
  });

  test(
    'reconcile() completes a session that has just crossed its planned end',
    () async {
      final container = makeContainer();
      await container.read(focusControllerProvider.future);
      final notifier = container.read(focusControllerProvider.notifier);

      await notifier.start(id: 'f1', plannedMinutes: 25);
      clock.advance(const Duration(minutes: 26));
      await notifier.reconcile();

      expect(container.read(focusControllerProvider).value, isNull);
    },
  );
}
