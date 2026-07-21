import 'package:flutter/material.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/medications/data/repositories/medications_repository.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// Medications' contribution to the global search index — registered at
/// `config/di/search_contributor_registrations.dart`, not imported by
/// `features/search` directly. Mirrors `HabitsSearchContributor`. Mood is
/// deliberately not indexed (see `mood`'s own doc comment on that
/// decision) — a medication's name lookup has clear standalone search
/// value, a journal note doesn't.
class MedicationsSearchContributor implements SearchContributor {
  const MedicationsSearchContributor(this._repository);

  final MedicationsRepository _repository;

  @override
  Stream<List<SearchableEntity>> contributions() {
    return _repository.watchActive().map(
      (medications) => [
        for (final medication in medications)
          SearchableEntity(
            id: 'medication-${medication.id}',
            title: medication.name,
            subtitle: medication.dosageText ?? 'Medication',
            icon: Icons.medication_outlined,
            category: SearchableEntityCategory.health,
            routeName: RouteNames.medicationDetail,
            pathParameters: {'medicationId': medication.id},
          ),
      ],
    );
  }
}
