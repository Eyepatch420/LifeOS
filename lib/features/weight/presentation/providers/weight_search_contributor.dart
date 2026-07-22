import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';
import 'package:lifeos/features/weight/data/repositories/weight_repository.dart';

/// Weight's contribution to the global search index — registered at
/// `config/di/search_contributor_registrations.dart`, not imported by
/// `features/search` directly. Mirrors `MedicationsSearchContributor`.
/// Unlike Medication, Weight has no per-entry detail route (its history
/// lives entirely on one screen), so every result routes to the same
/// [RouteNames.weight] screen — still useful for "find my weight from last
/// week" style searches even without a dedicated detail page per entry.
class WeightSearchContributor implements SearchContributor {
  const WeightSearchContributor(this._repository);

  final WeightRepository _repository;

  @override
  Stream<List<SearchableEntity>> contributions() {
    return _repository.watchAll().map(
      (entries) => [
        for (final entry in entries.take(30))
          SearchableEntity(
            id: 'weight-${entry.id}',
            title: '${entry.weightKg.toStringAsFixed(1)} kg',
            subtitle: DateFormat('MMM d, yyyy').format(entry.recordedAt),
            icon: Icons.monitor_weight_outlined,
            category: SearchableEntityCategory.health,
            routeName: RouteNames.weight,
          ),
      ],
    );
  }
}
