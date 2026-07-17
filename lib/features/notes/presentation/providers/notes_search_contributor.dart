import 'package:flutter/material.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/notes/data/repositories/notes_repository.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// Notes' contribution to the global search index — registered at
/// `config/di/search_contributor_registrations.dart`, not imported by
/// `features/search` directly.
class NotesSearchContributor implements SearchContributor {
  const NotesSearchContributor(this._repository);

  final NotesRepository _repository;

  @override
  Stream<List<SearchableEntity>> contributions() {
    return _repository.watchAll().map(
      (notes) => [
        for (final note in notes)
          SearchableEntity(
            id: 'note-${note.id}',
            title: note.title,
            subtitle: note.body,
            icon: Icons.note_alt_outlined,
            category: SearchableEntityCategory.note,
            routeName: RouteNames.noteDetail,
            pathParameters: {'noteId': note.id},
          ),
      ],
    );
  }
}
