import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/notifications_dao.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/notification_scheduler.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

/// The single subscriber to [EventBus]: maps every [DomainEvent] to a
/// [NotificationIntent] via whichever registered [NotificationContributor]
/// claims it, then (a) drives [NotificationScheduler] to
/// schedule/reschedule/cancel the OS-level notification and (b) persists an
/// in-app feed row via [NotificationsDao] for schedule intents. No
/// repository ever calls [NotificationScheduler] or [NotificationsDao]
/// directly — this is the one place that does (Architecture Constraint 5).
class NotificationEngine {
  NotificationEngine({
    required EventBus eventBus,
    required this.contributors,
    required this.scheduler,
    required this.notificationsDao,
    required this.idFactory,
  }) {
    _subscription = eventBus.events.listen(_handle);
  }

  final List<NotificationContributor> contributors;
  final NotificationScheduler scheduler;
  final NotificationsDao notificationsDao;
  final String Function() idFactory;
  late final StreamSubscription<DomainEvent> _subscription;

  Future<void> _handle(DomainEvent event) async {
    for (final contributor in contributors) {
      if (!contributor.handles(event)) continue;
      final intent = contributor.map(event);
      if (intent == null) return;

      switch (intent) {
        case ScheduleNotification():
          await scheduler.scheduleAt(
            id: intent.id,
            when: intent.when,
            title: intent.title,
            body: intent.body,
            payload: intent.payload,
          );
          await notificationsDao.insert(
            db.NotificationsCompanion.insert(
              id: idFactory(),
              sourceModule: event.sourceModule,
              sourceId: event.sourceId,
              title: intent.title,
              body: intent.body,
              createdAt: intent.when,
              readAt: const Value(null),
            ),
          );
        case CancelNotification():
          await scheduler.cancel(intent.id);
      }
      return;
    }
  }

  void dispose() => _subscription.cancel();
}
