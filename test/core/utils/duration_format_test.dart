import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/utils/duration_format.dart';

void main() {
  group('DurationFormat.toShortLabel', () {
    test('minutes only', () {
      expect(const Duration(minutes: 45).toShortLabel, '45 min');
    });

    test('whole hours omit the minutes segment', () {
      expect(const Duration(hours: 2).toShortLabel, '2 hr');
      expect(const Duration(hours: 1).toShortLabel, '1 hr');
    });

    test('hours and minutes combine', () {
      expect(
        const Duration(hours: 1, minutes: 30).toShortLabel,
        '1 hr 30 min',
      );
    });

    test('90 minutes formats as 1 hr 30 min, not 90 min', () {
      expect(const Duration(minutes: 90).toShortLabel, '1 hr 30 min');
    });

    test('1 hour 17 minutes custom duration', () {
      expect(
        const Duration(hours: 1, minutes: 17).toShortLabel,
        '1 hr 17 min',
      );
    });
  });
}
