import 'package:drift/native.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';
import 'package:lifeos/features/reminders/domain/contracts/reminders_summary.dart';
import 'package:lifeos/features/reminders/domain/events/reminder_events.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_notification_contributor.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_search_contributor.dart';

import '../../contracts/feature_contract_test_harness.dart';

/// Follows `notes_feature_contract_test.dart`'s exact shape — the template
/// this feature copied.
void main() {
  runFeatureContractTests<RemindersSummary>('Reminders', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final eventBus = EventBus();
    final repository = RemindersRepository(db.remindersDao, eventBus);

    await repository.create(
      id: 'r1',
      title: 'Seed',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );

    return FeatureContractFixture<RemindersSummary>(
      dashboardSummary: () async {
        final reminders = await repository.watchAll().first;
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
          pendingCount: reminders.where((r) => !r.isCompleted).length,
          completedTodayCount: 0,
        );
      },
      searchContributor: RemindersSearchContributor(repository),
      notificationContributor: const RemindersNotificationContributor(),
      sampleOwnEvent: ReminderCreated(
        reminderId: 'r1',
        title: 'Seed',
        dueAt: DateTime(2026, 1, 1),
      ),
      triggerNotifiableMutation: () => repository.create(
        id: 'r2',
        title: 'Trigger',
        dueAt: DateTime(2026, 1, 2),
        isUrgent: false,
      ),
    );
  });
}
