import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/calendar/domain/entities/event.dart';
import 'package:lifeos/features/calendar/domain/entities/event_status.dart';

void main() {
  final now = DateTime(2026, 7, 20, 12);

  Event timed({DateTime? startAt, DateTime? endAt}) => Event(
    id: 'e1',
    title: 'Event',
    startAt: startAt ?? now,
    endAt: endAt,
    isAllDay: false,
    createdAt: now,
  );

  Event allDay({required DateTime startAt, DateTime? endAt}) => Event(
    id: 'e1',
    title: 'Event',
    startAt: startAt,
    endAt: endAt,
    isAllDay: true,
    createdAt: now,
  );

  group('timed event with an end', () {
    test('upcoming when now is before start', () {
      final event = timed(
        startAt: now.add(const Duration(hours: 1)),
        endAt: now.add(const Duration(hours: 2)),
      );
      expect(eventStatus(event, now: now), EventStatus.upcoming);
    });

    test('ongoing when now is between start and end', () {
      final event = timed(
        startAt: now.subtract(const Duration(minutes: 30)),
        endAt: now.add(const Duration(minutes: 30)),
      );
      expect(eventStatus(event, now: now), EventStatus.ongoing);
    });

    test('past when now is at or after end', () {
      final event = timed(
        startAt: now.subtract(const Duration(hours: 2)),
        endAt: now.subtract(const Duration(hours: 1)),
      );
      expect(eventStatus(event, now: now), EventStatus.past);
    });

    test('past exactly at the end instant (end is exclusive of ongoing)', () {
      final event = timed(
        startAt: now.subtract(const Duration(hours: 1)),
        endAt: now,
      );
      expect(eventStatus(event, now: now), EventStatus.past);
    });
  });

  group('timed point event (no end)', () {
    test('upcoming before start', () {
      final event = timed(startAt: now.add(const Duration(minutes: 1)));
      expect(eventStatus(event, now: now), EventStatus.upcoming);
    });

    test('past at or after start — never ongoing', () {
      final event = timed(startAt: now);
      expect(eventStatus(event, now: now), EventStatus.past);
    });

    test('past well after start', () {
      final event = timed(startAt: now.subtract(const Duration(hours: 1)));
      expect(eventStatus(event, now: now), EventStatus.past);
    });
  });

  group('all-day event', () {
    test('ongoing for the entirety of a single covered day, any time', () {
      final event = allDay(startAt: DateTime(2026, 7, 20));
      expect(
        eventStatus(event, now: DateTime(2026, 7, 20, 0, 1)),
        EventStatus.ongoing,
      );
      expect(
        eventStatus(event, now: DateTime(2026, 7, 20, 23, 59)),
        EventStatus.ongoing,
      );
    });

    test('upcoming before the start day', () {
      final event = allDay(startAt: DateTime(2026, 7, 21));
      expect(eventStatus(event, now: now), EventStatus.upcoming);
    });

    test('past after the end day', () {
      final event = allDay(startAt: DateTime(2026, 7, 18));
      expect(eventStatus(event, now: now), EventStatus.past);
    });

    test('ongoing anywhere within a multi-day range', () {
      final event = allDay(
        startAt: DateTime(2026, 7, 19),
        endAt: DateTime(2026, 7, 22),
      );
      expect(
        eventStatus(event, now: DateTime(2026, 7, 21, 8)),
        EventStatus.ongoing,
      );
    });

    test('not fooled by a raw midnight-timestamp comparison', () {
      // Today's all-day event stored at midnight must still read as
      // ongoing at, say, 11pm — not "past" from a naive `now >= startAt`
      // check on the raw timestamp.
      final event = allDay(startAt: DateTime(2026, 7, 20));
      expect(
        eventStatus(event, now: DateTime(2026, 7, 20, 23)),
        EventStatus.ongoing,
      );
    });
  });
}
