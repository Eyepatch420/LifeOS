import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/notifications/notification_engine.dart';
import 'package:lifeos/core/services/notification_scheduler.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_notification_contributor.dart';

class _FakeScheduler implements NotificationScheduler {
  final List<String> scheduled = [];
  final List<String> cancelled = [];
  DateTime? lastScheduledWhen;
  String? lastScheduledTitle;

  @override
  Future<void> scheduleAt({
    required String id,
    required DateTime when,
    required String title,
    required String body,
    String? payload,
  }) async {
    scheduled.add(id);
    lastScheduledWhen = when;
    lastScheduledTitle = title;
  }

  @override
  Future<void> cancel(String id) async {
    cancelled.add(id);
  }

  @override
  Future<void> showOngoing({
    required String id,
    required String title,
    required String body,
    required DateTime countdownTo,
  }) async {}

  @override
  Future<void> cancelOngoing(String id) async {}
}

/// Exercises the real end-to-end flow this pass introduces:
/// RemindersRepository -> EventBus -> NotificationEngine -> NotificationScheduler.
/// No mocked contributor — this is the actual RemindersNotificationContributor.
void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late RemindersRepository repository;
  late _FakeScheduler scheduler;
  late NotificationEngine engine;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    repository = RemindersRepository(db.remindersDao, eventBus);
    scheduler = _FakeScheduler();
    engine = NotificationEngine(
      eventBus: eventBus,
      contributors: const [RemindersNotificationContributor()],
      scheduler: scheduler,
      notificationsDao: db.notificationsDao,
      idFactory: () => 'notif-1',
    );
  });

  tearDown(() async {
    engine.dispose();
    eventBus.dispose();
    await db.close();
  });

  test('creating a reminder schedules a notification at its dueAt', () async {
    final dueAt = DateTime(2026, 1, 1, 9);
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: dueAt,
      isUrgent: false,
    );
    await pumpEventQueue();

    expect(scheduler.scheduled, ['r1']);
    expect(scheduler.lastScheduledWhen, dueAt);
    expect(scheduler.lastScheduledTitle, 'Pay rent');
  });

  test('completing a reminder cancels its pending notification', () async {
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await pumpEventQueue();

    await repository.setCompleted('r1', true);
    await pumpEventQueue();

    expect(scheduler.cancelled, ['r1']);
  });

  test('deleting a reminder cancels its pending notification', () async {
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await pumpEventQueue();

    await repository.delete('r1');
    await pumpEventQueue();

    expect(scheduler.cancelled, ['r1']);
  });

  test('editing a reminder\'s dueAt reschedules the notification', () async {
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await pumpEventQueue();

    final newDueAt = DateTime(2026, 2, 1);
    await repository.update(
      id: 'r1',
      title: 'Pay rent (updated)',
      dueAt: newDueAt,
      isUrgent: false,
      recurrence: (await repository.getById('r1'))!.recurrence,
      category: (await repository.getById('r1'))!.category,
    );
    await pumpEventQueue();

    expect(scheduler.scheduled, ['r1', 'r1']);
    expect(scheduler.lastScheduledWhen, newDueAt);
    expect(scheduler.lastScheduledTitle, 'Pay rent (updated)');
  });

  test('completing a DAILY recurring reminder reschedules its notification '
      'for the next occurrence instead of cancelling it', () async {
    final dueAt = DateTime(2026, 6, 15, 9);
    await repository.create(
      id: 'r1',
      title: 'Take medicine',
      dueAt: dueAt,
      isUrgent: false,
      recurrence: RecurrenceRule.daily,
    );
    await pumpEventQueue();

    await repository.setCompleted('r1', true);
    await pumpEventQueue();

    // Rescheduled (scheduleAt overwrites the id-1 slot), never cancelled —
    // the series is still active.
    expect(scheduler.cancelled, isEmpty);
    expect(scheduler.scheduled, ['r1', 'r1']);
    expect(scheduler.lastScheduledWhen, DateTime(2026, 6, 16, 9));
  });

  test('completing a non-recurring reminder still cancels rather than '
      'reschedules', () async {
    await repository.create(
      id: 'r1',
      title: 'One-off',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await pumpEventQueue();

    await repository.setCompleted('r1', true);
    await pumpEventQueue();

    expect(scheduler.cancelled, ['r1']);
    expect(scheduler.scheduled, ['r1']);
  });
}
