import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/extensions/datetime_extensions.dart';

void main() {
  group('localDateKey', () {
    test('formats as yyyy-MM-dd', () {
      expect(DateTime(2026, 7, 16, 23, 59).localDateKey, '2026-07-16');
    });

    test('pads single-digit month and day', () {
      expect(DateTime(2026, 1, 5).localDateKey, '2026-01-05');
    });

    test('is stable across different times on the same day', () {
      final morning = DateTime(2026, 7, 16, 0, 1).localDateKey;
      final night = DateTime(2026, 7, 16, 23, 58).localDateKey;
      expect(morning, night);
    });

    test('differs across a midnight boundary', () {
      final beforeMidnight = DateTime(2026, 7, 16, 23, 59).localDateKey;
      final afterMidnight = DateTime(2026, 7, 17, 0, 1).localDateKey;
      expect(beforeMidnight, isNot(afterMidnight));
    });
  });
}
