import 'package:flutter/material.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category.dart';

/// Human-readable label for a [ReminderCategory] — shared by the New/Edit
/// form's picker and `ReminderDetailScreen`'s display so neither ever shows
/// a raw enum name (`ReminderCategory.appointment` etc).
String reminderCategoryLabel(ReminderCategory category) {
  return switch (category) {
    ReminderCategory.medicine => 'Medicine',
    ReminderCategory.meeting => 'Meeting',
    ReminderCategory.work => 'Work',
    ReminderCategory.study => 'Study',
    ReminderCategory.shopping => 'Shopping',
    ReminderCategory.bills => 'Bills',
    ReminderCategory.exercise => 'Exercise',
    ReminderCategory.walk => 'Walk',
    ReminderCategory.reading => 'Reading',
    ReminderCategory.travel => 'Travel',
    ReminderCategory.personal => 'Personal',
    ReminderCategory.family => 'Family',
    ReminderCategory.appointment => 'Appointment',
    ReminderCategory.home => 'Home',
    ReminderCategory.finance => 'Finance',
    ReminderCategory.documents => 'Documents',
    ReminderCategory.other => 'Other',
  };
}

/// The icon representing a [ReminderCategory] — the single source every
/// screen (New/Edit form, detail view, Agenda, Search) draws from, so no
/// icon is ever hardcoded for a specific category elsewhere.
IconData reminderCategoryIcon(ReminderCategory category) {
  return switch (category) {
    ReminderCategory.medicine => Icons.medication_outlined,
    ReminderCategory.meeting => Icons.groups_outlined,
    ReminderCategory.work => Icons.work_outline,
    ReminderCategory.study => Icons.school_outlined,
    ReminderCategory.shopping => Icons.shopping_cart_outlined,
    ReminderCategory.bills => Icons.receipt_long_outlined,
    ReminderCategory.exercise => Icons.fitness_center_outlined,
    ReminderCategory.walk => Icons.directions_walk_outlined,
    ReminderCategory.reading => Icons.menu_book_outlined,
    ReminderCategory.travel => Icons.flight_takeoff_outlined,
    ReminderCategory.personal => Icons.person_outline,
    ReminderCategory.family => Icons.family_restroom_outlined,
    ReminderCategory.appointment => Icons.event_outlined,
    ReminderCategory.home => Icons.home_outlined,
    ReminderCategory.finance => Icons.account_balance_wallet_outlined,
    ReminderCategory.documents => Icons.description_outlined,
    ReminderCategory.other => Icons.label_outline,
  };
}

/// The accent color representing a [ReminderCategory] — used for Agenda's
/// timeline dot and any future category-colored chip. Deliberately a small,
/// fixed palette (not one color per category) so the Agenda timeline stays
/// visually legible rather than becoming a rainbow.
Color reminderCategoryColor(ReminderCategory category) {
  return switch (category) {
    ReminderCategory.medicine => Colors.pinkAccent,
    ReminderCategory.meeting => Colors.indigo,
    ReminderCategory.work => Colors.indigo,
    ReminderCategory.study => Colors.deepPurple,
    ReminderCategory.shopping => Colors.orange,
    ReminderCategory.bills => Colors.orange,
    ReminderCategory.exercise => Colors.green,
    ReminderCategory.walk => Colors.green,
    ReminderCategory.reading => Colors.deepPurple,
    ReminderCategory.travel => Colors.teal,
    ReminderCategory.personal => Colors.blueGrey,
    ReminderCategory.family => Colors.pinkAccent,
    ReminderCategory.appointment => Colors.teal,
    ReminderCategory.home => Colors.brown,
    ReminderCategory.finance => Colors.orange,
    ReminderCategory.documents => Colors.blueGrey,
    ReminderCategory.other => Colors.blueGrey,
  };
}
