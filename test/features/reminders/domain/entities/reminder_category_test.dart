import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category_label.dart';

void main() {
  test('storageKey round-trips through fromStorageKey for every category', () {
    for (final category in ReminderCategory.values) {
      expect(ReminderCategory.fromStorageKey(category.storageKey), category);
    }
  });

  test('fromStorageKey falls back to other for an unknown key', () {
    expect(
      ReminderCategory.fromStorageKey('not-a-real-category'),
      ReminderCategory.other,
    );
  });

  test('every category has a non-empty label', () {
    for (final category in ReminderCategory.values) {
      expect(reminderCategoryLabel(category), isNotEmpty);
    }
  });

  test('every category maps to an icon and a color', () {
    for (final category in ReminderCategory.values) {
      expect(reminderCategoryIcon(category), isNotNull);
      expect(reminderCategoryColor(category), isNotNull);
    }
  });
}
