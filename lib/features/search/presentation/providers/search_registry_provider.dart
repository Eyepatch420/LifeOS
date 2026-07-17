import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/search_contributor_registrations.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_registry.dart';

/// The live, combined search index across every registered
/// [SearchContributor] (see `config/di/search_contributor_registrations.dart`
/// for the registration list — the one place allowed to import every
/// feature's contributor).
final searchRegistryProvider = Provider<SearchRegistry>((ref) {
  return SearchRegistry(searchContributors(ref));
});

final registeredSearchEntitiesProvider = StreamProvider<List<SearchableEntity>>(
  (ref) => ref.watch(searchRegistryProvider).watchAll(),
);
