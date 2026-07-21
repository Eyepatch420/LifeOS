import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';
import 'package:lifeos/features/reminders/domain/events/reminder_events.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_notification_contributor.dart';

void main() {
  const contributor = RemindersNotificationContributor();

  test('ReminderCreated maps to a ScheduleNotification with a '
      'reminder:<id> payload for tap routing', () {
    final due = DateTime(2026, 1, 1, 9);
    final intents = contributor.map(
      ReminderCreated(reminderId: 'r1', title: 'Water plants', dueAt: due),
    );
    final intent = intents.single as ScheduleNotification;

    expect(intent.id, 'r1');
    expect(intent.when, due);
    expect(intent.payload, 'reminder:r1');
  });

  test('ReminderUpdated reschedules with the same id and a fresh payload', () {
    final due = DateTime(2026, 1, 2, 10);
    final intents = contributor.map(
      ReminderUpdated(reminderId: 'r1', title: 'Water plants', dueAt: due),
    );
    final intent = intents.single as ScheduleNotification;

    expect(intent.id, 'r1');
    expect(intent.when, due);
    expect(intent.payload, 'reminder:r1');
  });

  test('ReminderCompleted cancels the pending notification', () {
    final intents = contributor.map(const ReminderCompleted(reminderId: 'r1'));
    expect(intents.single, isA<CancelNotification>());
    expect(intents.single.id, 'r1');
  });

  test('ReminderDeleted cancels the pending notification', () {
    final intents = contributor.map(const ReminderDeleted(reminderId: 'r1'));
    expect(intents.single, isA<CancelNotification>());
    expect(intents.single.id, 'r1');
  });
}
