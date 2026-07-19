import 'package:lifeos/core/events/domain_event.dart';

/// A Type A feature's contribution to the notification pipeline. Mirrors
/// [SearchContributor]/[AgendaContributor]'s shape deliberately: the
/// [NotificationEngine] never imports a feature's repository/entity types
/// either — it only consumes this interface, matching Architecture
/// Constraint 5 ("repositories never create notifications, they emit
/// events"). Registered at the composition layer
/// (`config/di/notification_contributor_registrations.dart`), not imported
/// by `features/notifications` directly.
///
/// Designed to cover, without a future redesign: the in-app notification
/// feed (`NotificationsDao`), real OS-level scheduling
/// (`NotificationScheduler`, Android/iOS), recurring reminders (an event
/// can be re-mapped to a new [ScheduleNotification] on every occurrence),
/// and future widgets/live activities (which read the same
/// [NotificationIntent] shape rather than a bespoke one).
abstract interface class NotificationContributor {
  /// Whether this contributor owns [event] (checked via `event.sourceModule`
  /// in the implementation) — [NotificationEngine] asks every registered
  /// contributor until one claims the event.
  bool handles(DomainEvent event);

  /// Maps a handled [event] to the notification to schedule/update/cancel.
  /// Returns `null` for events that don't correspond to a schedulable
  /// notification (e.g. Notes/Lists have no due-dated concept — they
  /// implement this interface to satisfy the five-part contract but
  /// legitimately have nothing to schedule).
  NotificationIntent? map(DomainEvent event);
}

/// What [NotificationEngine] should do in response to one [DomainEvent]:
/// schedule (or reschedule) a notification, or cancel a previously
/// scheduled one. `id` is stable per source entity so a later event
/// (update/delete) can address the same scheduled notification.
sealed class NotificationIntent {
  const NotificationIntent({required this.id});

  final String id;
}

class ScheduleNotification extends NotificationIntent {
  const ScheduleNotification({
    required super.id,
    required this.when,
    required this.title,
    required this.body,
    this.payload,
  });

  final DateTime when;
  final String title;
  final String body;

  /// Opaque string handed back verbatim on notification tap (see
  /// `NotificationScheduler.scheduleAt` / `notification_tap_dispatcher.dart`)
  /// so a tap can be routed to a specific destination. `null` for
  /// contributors with nothing to deep-link to (a tap just opens the app).
  final String? payload;
}

class CancelNotification extends NotificationIntent {
  const CancelNotification({required super.id});
}
