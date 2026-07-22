import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';
import 'package:lifeos/features/sleep/data/repositories/sleep_repository.dart';

String _formatDuration(Duration d) => '${d.inHours}h ${d.inMinutes % 60}m';

/// Sleep's contribution to the global search index — registered at
/// `config/di/search_contributor_registrations.dart`, not imported by
/// `features/search` directly. Mirrors `WeightSearchContributor` — Sleep
/// also has no per-entry detail route, so every result routes to the same
/// [RouteNames.sleep] screen.
class SleepSearchContributor implements SearchContributor {
  const SleepSearchContributor(this._repository);

  final SleepRepository _repository;

  @override
  Stream<List<SearchableEntity>> contributions() {
    return _repository.watchAll().map(
      (entries) => [
        for (final entry in entries.take(30))
          SearchableEntity(
            id: 'sleep-${entry.id}',
            title: _formatDuration(entry.duration),
            subtitle: DateFormat('MMM d, yyyy').format(entry.sleepDay),
            icon: Icons.bedtime_outlined,
            category: SearchableEntityCategory.health,
            routeName: RouteNames.sleep,
          ),
      ],
    );
  }
}
