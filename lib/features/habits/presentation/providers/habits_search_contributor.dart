import 'package:flutter/material.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/habits/data/repositories/habits_repository.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// Habits' contribution to the global search index — registered at
/// `config/di/search_contributor_registrations.dart`, not imported by
/// `features/search` directly. Mirrors `RemindersSearchContributor`.
class HabitsSearchContributor implements SearchContributor {
  const HabitsSearchContributor(this._repository);

  final HabitsRepository _repository;

  @override
  Stream<List<SearchableEntity>> contributions() {
    return _repository.watchAll().map(
      (habits) => [
        for (final habit in habits)
          SearchableEntity(
            id: 'habit-${habit.id}',
            title: habit.title,
            subtitle: habit.schedule.isDaily ? 'Daily' : 'Weekly',
            icon: Icons.track_changes_outlined,
            category: SearchableEntityCategory.habit,
            routeName: RouteNames.habitDetail,
            pathParameters: {'habitId': habit.id},
          ),
      ],
    );
  }
}
