import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/presentation/providers/search_registry_provider.dart';

/// Live search query text, updated as the user types in `SearchScreen`.
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

/// Fixed placeholder entries for tabs with no real searchable content or
/// [SearchContributor] yet (Health/Finance/Documents/Settings). Notes,
/// Lists, and Reminders are removed from here once their real contributors
/// register (see Phase 2B/2C and Module 4 Phase 3) — this list shrinks to
/// nothing once every category has a contributor rather than being
/// replaced wholesale.
final _placeholderEntitiesProvider = Provider<List<SearchableEntity>>((ref) {
  return const [
    SearchableEntity(
      id: 'tab-health',
      title: 'Health',
      subtitle: 'Open Health workspace',
      icon: Icons.favorite_outline,
      category: SearchableEntityCategory.health,
      routeName: RouteNames.health,
    ),
    SearchableEntity(
      id: 'tab-finance',
      title: 'Finance',
      subtitle: 'Open Finance workspace',
      icon: Icons.account_balance_wallet_outlined,
      category: SearchableEntityCategory.finance,
      routeName: RouteNames.finance,
    ),
    SearchableEntity(
      id: 'tab-documents',
      title: 'Documents',
      subtitle: 'Open Documents workspace',
      icon: Icons.folder_outlined,
      category: SearchableEntityCategory.documents,
      routeName: RouteNames.documents,
    ),
    SearchableEntity(
      id: 'tab-settings',
      title: 'Settings',
      subtitle: 'App settings — coming soon',
      icon: Icons.settings_outlined,
      category: SearchableEntityCategory.settings,
      routeName: RouteNames.profile,
    ),
  ];
});

/// The full, unfiltered search index — every registered
/// [SearchContributor]'s live entities (Notes/Lists as of Phase 2B/2C,
/// Reminders as of Module 4 Phase 3) plus the remaining tab placeholders
/// above. Kept separate from [searchResultsProvider] (the filtered view)
/// so a future feature (e.g. a command palette) could reuse this raw index
/// without duplicating the aggregation logic.
final searchableEntitiesProvider = Provider<List<SearchableEntity>>((ref) {
  final registered = ref.watch(registeredSearchEntitiesProvider).value;
  final placeholders = ref.watch(_placeholderEntitiesProvider);
  return [...?registered, ...placeholders];
});

/// [searchableEntitiesProvider] filtered by [searchQueryProvider] (a
/// case-insensitive substring match on title/subtitle). An empty query
/// returns the full index — "browse" mode before the user types anything.
final searchResultsProvider = Provider<List<SearchableEntity>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final entities = ref.watch(searchableEntitiesProvider);
  if (query.isEmpty) return entities;
  return entities
      .where(
        (e) =>
            e.title.toLowerCase().contains(query) ||
            e.subtitle.toLowerCase().contains(query),
      )
      .toList();
});
