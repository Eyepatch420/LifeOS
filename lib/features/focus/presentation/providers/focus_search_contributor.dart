import 'package:flutter/material.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// Focus's contribution to the global search index. Unlike a Type A
/// feature's contributor (one entry per persisted row — see
/// `RemindersSearchContributor`), Focus is Type B/global: the single
/// searchable thing is the feature/dashboard itself, not individual
/// historical sessions — there's no product need to search "my focus
/// session from Tuesday" yet (see docs/architecture_principles.md's Type B
/// definition and this feature's module doc for why). A single-element
/// stream satisfies [SearchContributor]'s interface without pretending
/// there's a repository backing it.
class FocusSearchContributor implements SearchContributor {
  const FocusSearchContributor();

  @override
  Stream<List<SearchableEntity>> contributions() {
    return Stream.value(const [
      SearchableEntity(
        id: 'focus',
        title: 'Focus',
        subtitle: 'Start a focus session',
        icon: Icons.timer_outlined,
        category: SearchableEntityCategory.focus,
        routeName: RouteNames.focus,
      ),
    ]);
  }
}
