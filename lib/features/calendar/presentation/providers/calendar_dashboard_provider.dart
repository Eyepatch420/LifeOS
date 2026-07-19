import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/calendar/data/repositories/events_repository.dart';
import 'package:lifeos/features/calendar/domain/contracts/calendar_summary.dart';
import 'package:lifeos/features/calendar/domain/entities/event.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepository(
    ref.watch(databaseProvider).eventsDao,
    ref.watch(eventBusProvider),
  );
});

/// The Calendar feature's own dashboard provider — the only thing another
/// feature (Home) is allowed to `ref.watch()`. Maps the repository's
/// stream to [CalendarSummary]: events today-or-later, soonest-first, plus
/// `todayCount` for a future Overview Stats tile. Home never sees [Event]
/// or [EventsRepository].
final calendarDashboardProvider = StreamProvider<CalendarSummary>((ref) {
  return ref.watch(eventsRepositoryProvider).watchAll().map((events) {
    final now = DateTime.now();
    final today = dateOnly(now);

    final upcoming = events.where((e) => _endInstant(e).isAfter(now)).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    final todayCount = events.where((e) => isSameDay(e.startAt, today)).length;

    return CalendarSummary(
      upcoming: [
        for (final event in upcoming)
          UpcomingEventSummary(
            id: event.id,
            title: event.title,
            startAt: event.startAt,
            isAllDay: event.isAllDay,
          ),
      ],
      todayCount: todayCount,
    );
  });
});

DateTime _endInstant(Event event) => event.endAt ?? event.startAt;
