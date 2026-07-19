import 'package:drift/native.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/calendar/data/repositories/events_repository.dart';
import 'package:lifeos/features/calendar/domain/contracts/calendar_summary.dart';
import 'package:lifeos/features/calendar/domain/events/event_events.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_notification_contributor.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_search_contributor.dart';

import '../../contracts/feature_contract_test_harness.dart';

/// Follows `habits_feature_contract_test.dart`'s exact shape. Unlike
/// Habits, Calendar DOES have an `AgendaContributor` (see
/// `CalendarAgendaContributor`'s doc comment) — not part of this shared
/// harness (which only covers dashboard/search/notification, the three
/// pieces every Type A feature has in common), but exercised separately in
/// `calendar_agenda_contributor_test.dart`.
void main() {
  runFeatureContractTests<CalendarSummary>('Calendar', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final eventBus = EventBus();
    final repository = EventsRepository(db.eventsDao, eventBus);

    await repository.create(
      id: 'e1',
      title: 'Seed',
      startAt: DateTime.now().add(const Duration(hours: 1)),
      isAllDay: false,
    );

    return FeatureContractFixture<CalendarSummary>(
      dashboardSummary: () async {
        final events = await repository.watchAll().first;
        return CalendarSummary(
          upcoming: [
            for (final event in events)
              UpcomingEventSummary(
                id: event.id,
                title: event.title,
                startAt: event.startAt,
                isAllDay: event.isAllDay,
              ),
          ],
          todayCount: events.length,
        );
      },
      searchContributor: CalendarSearchContributor(repository),
      notificationContributor: const CalendarNotificationContributor(),
      sampleOwnEvent: EventCreated(
        eventId: 'e1',
        title: 'Seed',
        startAt: DateTime.now(),
        isAllDay: false,
      ),
      triggerNotifiableMutation: () => repository.create(
        id: 'e2',
        title: 'Trigger',
        startAt: DateTime.now().add(const Duration(hours: 2)),
        isAllDay: false,
      ),
    );
  });
}
