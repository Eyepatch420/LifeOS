import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/focus/domain/events/focus_events.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_notification_contributor.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

void main() {
  const contributor = FocusNotificationContributor();

  test('FocusSessionStarted schedules the completion alarm AND shows the '
      'ongoing countdown, both keyed by the same session id', () {
    final endAt = DateTime(2026, 1, 1, 9, 25);
    final intents = contributor.map(
      FocusSessionStarted(sessionId: 's1', projectedEndAt: endAt),
    );

    expect(intents, hasLength(2));
    final schedule = intents.whereType<ScheduleNotification>().single;
    final ongoing = intents.whereType<ShowOngoingNotification>().single;

    expect(schedule.id, 's1');
    expect(schedule.when, endAt);
    expect(schedule.payload, 'focus:s1');
    expect(ongoing.id, 's1');
    expect(ongoing.countdownTo, endAt);
  });

  test('FocusSessionResumed reschedules the alarm and refreshes the '
      'ongoing countdown against the new projected end time', () {
    final endAt = DateTime(2026, 1, 1, 9, 40);
    final intents = contributor.map(
      FocusSessionResumed(sessionId: 's1', projectedEndAt: endAt),
    );

    expect(intents, hasLength(2));
    expect(intents.whereType<ScheduleNotification>().single.when, endAt);
    expect(
      intents.whereType<ShowOngoingNotification>().single.countdownTo,
      endAt,
    );
  });

  test('FocusSessionPaused cancels both the alarm and the ongoing display', () {
    final intents = contributor.map(const FocusSessionPaused(sessionId: 's1'));

    expect(intents, hasLength(2));
    expect(intents.whereType<CancelNotification>().single.id, 's1');
    expect(intents.whereType<CancelOngoingNotification>().single.id, 's1');
  });

  test(
    'FocusSessionCompleted cancels both the alarm and the ongoing display',
    () {
      final intents = contributor.map(
        const FocusSessionCompleted(sessionId: 's1'),
      );

      expect(intents, hasLength(2));
      expect(intents.whereType<CancelNotification>().single.id, 's1');
      expect(intents.whereType<CancelOngoingNotification>().single.id, 's1');
    },
  );

  test(
    'FocusSessionCancelled cancels both the alarm and the ongoing display',
    () {
      final intents = contributor.map(
        const FocusSessionCancelled(sessionId: 's1'),
      );

      expect(intents, hasLength(2));
      expect(intents.whereType<CancelNotification>().single.id, 's1');
      expect(intents.whereType<CancelOngoingNotification>().single.id, 's1');
    },
  );
}
