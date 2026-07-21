import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/services/notification_scheduler.dart';
import 'package:lifeos/features/medications/domain/events/medication_events.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

/// Medications' contribution to the notification pipeline. A pure mapper
/// with no repository dependency: [MedicationScheduleChanged] already
/// carries both [MedicationScheduleChanged.oldSlotIds] (what to cancel) and
/// [MedicationScheduleChanged.newSlots] (what to (re)schedule), computed by
/// [MedicationsRepository] — this never needs an async re-read inside the
/// synchronous [map] call (mirrors `RemindersNotificationContributor`).
///
/// Cancels every old slot id that isn't also a new slot id (a genuinely
/// removed/changed slot), then schedules every new slot — collision-safe by
/// construction, since each slot id is already `"$medicationId:$hhmm"`
/// (unique per medication+time) before it ever reaches this contributor.
/// Repeated delivery of the same diff (e.g. a startup reconciliation replay
/// with `oldSlotIds: []`) is naturally idempotent: cancelling a
/// non-existent id is a safe no-op, and `scheduleAt` on an existing id
/// overwrites in place — never a duplicate OS notification.
class MedicationsNotificationContributor implements NotificationContributor {
  const MedicationsNotificationContributor();

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'medications';

  @override
  List<NotificationIntent> map(DomainEvent event) {
    if (event is! MedicationScheduleChanged) return const [];
    final newSlotIds = event.newSlots.map((s) => s.slotId).toSet();
    return [
      for (final oldId in event.oldSlotIds)
        if (!newSlotIds.contains(oldId)) CancelNotification(id: oldId),
      for (final slot in event.newSlots)
        ScheduleNotification(
          id: slot.slotId,
          when: slot.nextOccurrence,
          title: slot.title,
          body: slot.body,
          payload: 'medication:${event.sourceId}',
          channel: AppNotificationChannel.medicationReminders,
        ),
    ];
  }
}
