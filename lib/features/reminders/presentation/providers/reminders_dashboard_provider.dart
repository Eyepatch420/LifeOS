import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';
import 'package:lifeos/features/reminders/domain/contracts/reminders_summary.dart';

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  return RemindersRepository(
    ref.watch(databaseProvider).remindersDao,
    ref.watch(eventBusProvider),
  );
});

/// The Reminders feature's own dashboard provider — the only thing another
/// feature (Home) is allowed to `ref.watch()`. Maps the repository's
/// stream to [RemindersSummary]: non-completed reminders sorted
/// soonest-first, plus `pendingCount`/`completedTodayCount` for Home's
/// Overview Stats "Tasks" tile. Home never sees [Reminder] or
/// [RemindersRepository].
final remindersDashboardProvider = StreamProvider<RemindersSummary>((ref) {
  return ref.watch(remindersRepositoryProvider).watchAll().map((reminders) {
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);

    final pending = reminders.where((r) => !r.isCompleted).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

    final completedToday = reminders.where((r) {
      final completedAt = r.completedAt;
      if (!r.isCompleted || completedAt == null) return false;
      final completedDay = DateTime(
        completedAt.year,
        completedAt.month,
        completedAt.day,
      );
      return completedDay == todayKey;
    }).length;

    return RemindersSummary(
      items: [
        for (final reminder in reminders)
          ReminderEntrySummary(
            id: reminder.id,
            title: reminder.title,
            dueAt: reminder.dueAt,
            isUrgent: reminder.isUrgent,
            isCompleted: reminder.isCompleted,
          ),
      ],
      pendingCount: pending.length,
      completedTodayCount: completedToday,
    );
  });
});
