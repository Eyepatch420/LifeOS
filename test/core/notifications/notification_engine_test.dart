import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/notifications/notification_engine.dart';
import 'package:lifeos/core/services/notification_scheduler.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

class _TestEvent extends DomainEvent {
  const _TestEvent(String id) : super(sourceModule: 'reminders', sourceId: id);
}

class _FakeContributor implements NotificationContributor {
  final List<DomainEvent> handled = [];
  List<NotificationIntent> Function(DomainEvent event)? onMap;

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'reminders';

  @override
  List<NotificationIntent> map(DomainEvent event) {
    handled.add(event);
    return onMap?.call(event) ?? const [];
  }
}

class _FakeScheduler implements NotificationScheduler {
  final List<String> scheduled = [];
  final List<String> cancelled = [];
  final List<String> ongoingShown = [];
  final List<String> ongoingCancelled = [];

  @override
  Future<void> scheduleAt({
    required String id,
    required DateTime when,
    required String title,
    required String body,
    String? payload,
  }) async {
    scheduled.add(id);
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
  }) async {
    ongoingShown.add(id);
  }

  @override
  Future<void> cancelOngoing(String id) async {
    ongoingCancelled.add(id);
  }
}

void main() {
  late AppDatabase db;
  late EventBus bus;
  late _FakeContributor contributor;
  late _FakeScheduler scheduler;
  late NotificationEngine engine;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    bus = EventBus();
    contributor = _FakeContributor();
    scheduler = _FakeScheduler();
    engine = NotificationEngine(
      eventBus: bus,
      contributors: [contributor],
      scheduler: scheduler,
      notificationsDao: db.notificationsDao,
      idFactory: () => 'notif-1',
    );
  });

  tearDown(() async {
    engine.dispose();
    bus.dispose();
    await db.close();
  });

  test(
    'a ScheduleNotification intent schedules and persists a feed row',
    () async {
      final when = DateTime(2026, 1, 1, 9);
      contributor.onMap = (event) => [
        ScheduleNotification(
          id: event.sourceId,
          when: when,
          title: 'Reminder',
          body: 'Do the thing',
        ),
      ];

      bus.emit(const _TestEvent('r1'));
      await pumpEventQueue();

      expect(scheduler.scheduled, ['r1']);
      final rows = await db.notificationsDao.watchAll().first;
      expect(rows, hasLength(1));
      expect(rows.single.sourceModule, 'reminders');
      expect(rows.single.sourceId, 'r1');
      expect(rows.single.title, 'Reminder');
    },
  );

  test(
    'a CancelNotification intent cancels without persisting a feed row',
    () async {
      contributor.onMap = (event) => [CancelNotification(id: event.sourceId)];

      bus.emit(const _TestEvent('r1'));
      await pumpEventQueue();

      expect(scheduler.cancelled, ['r1']);
      final rows = await db.notificationsDao.watchAll().first;
      expect(rows, isEmpty);
    },
  );

  test(
    'a ScheduleNotification + ShowOngoingNotification pair (Focus start) '
    'both act on the same event',
    () async {
      final when = DateTime(2026, 1, 1, 9);
      contributor.onMap = (event) => [
        ScheduleNotification(
          id: event.sourceId,
          when: when,
          title: 'Focus session complete',
          body: 'Done',
        ),
        ShowOngoingNotification(
          id: event.sourceId,
          title: 'Focus session in progress',
          body: 'Tap to return',
          countdownTo: when,
        ),
      ];

      bus.emit(const _TestEvent('f1'));
      await pumpEventQueue();

      expect(scheduler.scheduled, ['f1']);
      expect(scheduler.ongoingShown, ['f1']);
    },
  );

  test(
    'a CancelNotification + CancelOngoingNotification pair (Focus pause) '
    'both act on the same event',
    () async {
      contributor.onMap = (event) => [
        CancelNotification(id: event.sourceId),
        CancelOngoingNotification(id: event.sourceId),
      ];

      bus.emit(const _TestEvent('f1'));
      await pumpEventQueue();

      expect(scheduler.cancelled, ['f1']);
      expect(scheduler.ongoingCancelled, ['f1']);
    },
  );

  test('an event with no schedulable intent is ignored', () async {
    contributor.onMap = (event) => const [];

    bus.emit(const _TestEvent('r1'));
    await pumpEventQueue();

    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.cancelled, isEmpty);
  });

  test('an event no contributor handles is ignored', () async {
    final unhandled = _FakeContributor()
      ..onMap = (_) => throw StateError('should not be called');
    engine.dispose();
    engine = NotificationEngine(
      eventBus: bus,
      contributors: [],
      scheduler: scheduler,
      notificationsDao: db.notificationsDao,
      idFactory: () => 'notif-1',
    );

    bus.emit(const _TestEvent('r1'));
    await pumpEventQueue();

    expect(scheduler.scheduled, isEmpty);
    expect(unhandled.handled, isEmpty);
  });
}
