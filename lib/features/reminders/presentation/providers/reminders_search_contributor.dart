import 'package:flutter/material.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// Reminders' contribution to the global search index — registered at
/// `config/di/search_contributor_registrations.dart`, not imported by
/// `features/search` directly. Mirrors `NotesSearchContributor` exactly.
class RemindersSearchContributor implements SearchContributor {
  const RemindersSearchContributor(this._repository);

  final RemindersRepository _repository;

  @override
  Stream<List<SearchableEntity>> contributions() {
    return _repository.watchAll().map(
      (reminders) => [
        for (final reminder in reminders)
          SearchableEntity(
            id: 'reminder-${reminder.id}',
            title: reminder.title,
            subtitle: reminder.isCompleted
                ? 'Completed'
                : 'Due ${reminder.dueAt}',
            icon: Icons.notifications_active_outlined,
            category: SearchableEntityCategory.reminder,
            routeName: RouteNames.reminderDetail,
            pathParameters: {'reminderId': reminder.id},
          ),
      ],
    );
  }
}
