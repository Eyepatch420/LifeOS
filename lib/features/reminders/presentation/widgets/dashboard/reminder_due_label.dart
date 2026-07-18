import 'package:intl/intl.dart';

/// A short, human-readable label for a reminder's `dueAt`, relative to
/// [now] — shared by Up Next/Today/Upcoming dashboard tiles so all three
/// describe due dates consistently. Not used by `ReminderDetailScreen` or
/// `RemindersListScreen`, which show the raw due date/time in their own
/// established (more verbose) styles.
String reminderDueLabel(DateTime dueAt, {required DateTime now}) {
  final todayKey = DateTime(now.year, now.month, now.day);
  final dueKey = DateTime(dueAt.year, dueAt.month, dueAt.day);
  final dayDiff = dueKey.difference(todayKey).inDays;
  final time = DateFormat('h:mm a').format(dueAt);

  if (dayDiff == 0) return time;
  if (dayDiff == 1) return 'Tomorrow, $time';
  if (dayDiff == -1) return 'Yesterday, $time';
  return '${DateFormat('EEE, d MMM').format(dueAt)}, $time';
}
