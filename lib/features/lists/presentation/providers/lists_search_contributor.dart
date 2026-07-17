import 'package:flutter/material.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/lists/data/repositories/lists_repository.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// Lists' contribution to the global search index — registered at
/// `config/di/search_contributor_registrations.dart`, not imported by
/// `features/search` directly.
class ListsSearchContributor implements SearchContributor {
  const ListsSearchContributor(this._repository);

  final ListsRepository _repository;

  @override
  Stream<List<SearchableEntity>> contributions() {
    return _repository.watchAll().map(
      (lists) => [
        for (final list in lists)
          SearchableEntity(
            id: 'list-${list.id}',
            title: list.title,
            subtitle: list.items.isEmpty
                ? 'No items yet'
                : '${list.items.length} items',
            icon: Icons.checklist_outlined,
            category: SearchableEntityCategory.list,
            routeName: RouteNames.listDetail,
            pathParameters: {'listId': list.id},
          ),
      ],
    );
  }
}
