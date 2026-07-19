import 'package:flutter/material.dart';
import 'package:lifeos/core/agenda/agenda_contributor.dart';
import 'package:lifeos/core/agenda/agenda_entry.dart';
import 'package:lifeos/features/calendar/data/repositories/events_repository.dart';
import 'package:lifeos/features/calendar/domain/entities/event.dart';
import 'package:lifeos/features/calendar/domain/entities/event_status.dart';

/// Calendar's contribution to the shared cross-feature Agenda (Home's Up
/// Next/Timeline). Registered at
/// `config/di/agenda_contributor_registrations.dart`, not imported by
/// `core/agenda/` or `features/home/` directly.
///
/// Unlike Habits (deliberately absent — see that registration site's
/// comment), events naturally belong here: they carry a real instant
/// ([Event.startAt]). Only [EventStatus.upcoming]/[EventStatus.ongoing]
/// events are surfaced — a genuinely [EventStatus.past] event is never
/// "up next" and including every past event indefinitely would make the
/// Agenda grow unbounded (see this phase's requirement against showing old
/// past events). [AgendaEntry.isAllDay] mirrors [Event.isAllDay] so Home's
/// Timeline/Up Next can group/label all-day events distinctly instead of
/// rendering a fabricated midnight time.
class CalendarAgendaContributor implements AgendaContributor {
  const CalendarAgendaContributor(this._repository);

  final EventsRepository _repository;

  @override
  Stream<List<AgendaEntry>> contributions() {
    return _repository.watchAll().map((events) {
      final now = DateTime.now();
      return [
        for (final event in events)
          if (eventStatus(event, now: now) != EventStatus.past)
            AgendaEntry(
              id: event.id,
              sourceModule: 'calendar',
              sourceId: event.id,
              icon: Icons.event_outlined,
              title: event.title,
              time: event.startAt,
              dotColor: Colors.purple,
              isUrgent: false,
              isAllDay: event.isAllDay,
            ),
      ];
    });
  }

  /// Events have no "dismiss" concept distinct from deletion — Home's Up
  /// Next/Timeline dismiss action doesn't apply to an event the way it does
  /// a completable reminder, so this intentionally no-ops (mirrors how
  /// `AgendaRegistry.dismiss` already tolerates a contributor for which
  /// [id] doesn't belong to it).
  @override
  Future<void> dismiss(String id) async {}
}
