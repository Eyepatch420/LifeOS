import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/calendar/data/repositories/events_repository.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// Calendar's contribution to the global search index — registered at
/// `config/di/search_contributor_registrations.dart`, not imported by
/// `features/search` directly. Mirrors `HabitsSearchContributor`. Searches
/// by title (and description, folded into [SearchableEntity.subtitle] so
/// `SearchScreen`'s existing rendering needs no change) via
/// `SearchScreen`/`search_providers.dart`'s existing query-filter logic —
/// this contributor just exposes the full live set of events.
class CalendarSearchContributor implements SearchContributor {
  const CalendarSearchContributor(this._repository);

  final EventsRepository _repository;

  @override
  Stream<List<SearchableEntity>> contributions() {
    return _repository.watchAll().map(
      (events) => [
        for (final event in events)
          SearchableEntity(
            id: 'event-${event.id}',
            title: event.title,
            subtitle: event.isAllDay
                ? 'All day'
                : DateFormat('EEE, d MMM • h:mm a').format(event.startAt),
            icon: Icons.event_outlined,
            category: SearchableEntityCategory.calendar,
            routeName: RouteNames.eventDetail,
            pathParameters: {'eventId': event.id},
          ),
      ],
    );
  }
}
