import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';

void main() {
  FocusSession session({
    required DateTime startedAt,
    required int plannedMinutes,
    FocusSessionStatus status = FocusSessionStatus.running,
  }) {
    return FocusSession(
      id: 's1',
      startedAt: startedAt,
      plannedMinutes: plannedMinutes,
      kind: FocusSessionKind.focus,
      status: status,
    );
  }

  group('hasNaturallyCompletedAt', () {
    final start = DateTime(2026, 1, 1, 9);

    test('false before the planned end', () {
      final s = session(startedAt: start, plannedMinutes: 25);
      expect(
        s.hasNaturallyCompletedAt(start.add(const Duration(minutes: 24))),
        isFalse,
      );
    });

    test('true exactly at the planned end (<=, not exact-instant)', () {
      final s = session(startedAt: start, plannedMinutes: 25);
      expect(
        s.hasNaturallyCompletedAt(start.add(const Duration(minutes: 25))),
        isTrue,
      );
    });

    test('remains true well past the planned end — a ticker sampling once a '
        'second must not skip past the single millisecond an exact-instant '
        'check would require', () {
      final s = session(startedAt: start, plannedMinutes: 25);
      expect(
        s.hasNaturallyCompletedAt(start.add(const Duration(minutes: 30))),
        isTrue,
      );
      expect(
        s.hasNaturallyCompletedAt(start.add(const Duration(hours: 2))),
        isTrue,
      );
    });

    test('false for a paused session even past the planned end — pausing '
        'stops the projected end from being meaningful until resumed', () {
      final s = session(
        startedAt: start,
        plannedMinutes: 25,
        status: FocusSessionStatus.paused,
      );
      expect(
        s.hasNaturallyCompletedAt(start.add(const Duration(hours: 1))),
        isFalse,
      );
    });

    test('false for an already-completed session', () {
      final s = session(
        startedAt: start,
        plannedMinutes: 25,
        status: FocusSessionStatus.completed,
      );
      expect(
        s.hasNaturallyCompletedAt(start.add(const Duration(hours: 1))),
        isFalse,
      );
    });
  });

  group('remainingAt clamps to zero', () {
    test('never goes negative once elapsed exceeds planned duration', () {
      final s = session(startedAt: DateTime(2026, 1, 1, 9), plannedMinutes: 15);
      final farPast = DateTime(2026, 1, 1, 12);
      expect(s.remainingAt(farPast), Duration.zero);
      expect(s.elapsedAt(farPast), const Duration(minutes: 15));
    });
  });

  group('stage derivation with a custom (non-preset) duration', () {
    test('a 90-minute session divides into thirds the same way a 15-minute '
        'one does — stage derivation must stay duration-agnostic', () {
      final s = session(startedAt: DateTime(2026, 1, 1, 9), plannedMinutes: 90);
      final now = DateTime(2026, 1, 1, 9);

      expect(s.progressAt(now.add(const Duration(minutes: 29))), lessThan(1 / 3));
      expect(
        s.progressAt(now.add(const Duration(minutes: 31))),
        allOf(greaterThan(1 / 3), lessThan(2 / 3)),
      );
      expect(s.progressAt(now.add(const Duration(minutes: 61))), greaterThan(2 / 3));
    });
  });
}
