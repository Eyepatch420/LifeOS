import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/services/notification_scheduler.dart';
import 'package:lifeos/features/medications/domain/events/medication_events.dart';
import 'package:lifeos/features/medications/presentation/providers/medications_notification_contributor.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

void main() {
  const contributor = MedicationsNotificationContributor();

  test('handles only medications-sourced events', () {
    expect(
      contributor.handles(
        const MedicationScheduleChanged(
          medicationId: 'm1',
          oldSlotIds: [],
          newSlots: [],
        ),
      ),
      isTrue,
    );
  });

  test('maps a schedule change to cancel intents for removed slots and '
      'schedule intents for every new slot, on the medication_reminders '
      'channel with a medication: deep-link payload', () {
    final when = DateTime(2026, 1, 2, 9);
    final intents = contributor.map(
      MedicationScheduleChanged(
        medicationId: 'm1',
        oldSlotIds: const ['m1:09:00', 'm1:21:00'],
        newSlots: [
          MedicationScheduleSlotChange(
            slotId: 'm1:10:00',
            nextOccurrence: when,
            title: 'Vitamin D',
            body: 'Time to take Vitamin D',
          ),
        ],
      ),
    );

    final cancels = intents.whereType<CancelNotification>().toList();
    final schedules = intents.whereType<ScheduleNotification>().toList();

    // Both old ids are absent from the new set, so both get cancelled.
    expect(cancels.map((c) => c.id).toSet(), {'m1:09:00', 'm1:21:00'});
    expect(schedules, hasLength(1));
    expect(schedules.single.id, 'm1:10:00');
    expect(schedules.single.when, when);
    expect(schedules.single.payload, 'medication:m1');
    expect(
      schedules.single.channel,
      AppNotificationChannel.medicationReminders,
    );
  });

  test(
    'a slot id present in both old and new is not cancelled — only genuinely '
    'removed slots are',
    () {
      final intents = contributor.map(
        MedicationScheduleChanged(
          medicationId: 'm1',
          oldSlotIds: const ['m1:09:00'],
          newSlots: [
            MedicationScheduleSlotChange(
              slotId: 'm1:09:00',
              nextOccurrence: DateTime(2026, 1, 2, 9),
              title: 'Vitamin D',
              body: 'Time to take Vitamin D',
            ),
          ],
        ),
      );

      expect(intents.whereType<CancelNotification>(), isEmpty);
      expect(intents.whereType<ScheduleNotification>(), hasLength(1));
    },
  );

  test('archival (empty newSlots) only cancels, schedules nothing', () {
    final intents = contributor.map(
      const MedicationScheduleChanged(
        medicationId: 'm1',
        oldSlotIds: ['m1:09:00', 'm1:21:00'],
        newSlots: [],
      ),
    );

    expect(intents.whereType<ScheduleNotification>(), isEmpty);
    expect(intents.whereType<CancelNotification>(), hasLength(2));
  });

  test('an unrelated event maps to no intents', () {
    expect(contributor.handles(const _OtherEvent()), isFalse);
  });
}

class _OtherEvent extends DomainEvent {
  const _OtherEvent() : super(sourceModule: 'reminders', sourceId: 'x');
}
