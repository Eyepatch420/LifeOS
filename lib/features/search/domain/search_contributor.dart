import 'package:lifeos/features/search/domain/models/searchable_entity.dart';

/// A Type A feature's contribution to the global search index. Search never
/// imports a feature's repository/entity types — instead each feature
/// implements this and registers an instance at the composition layer
/// (`config/di/`), so adding a new searchable feature never requires a
/// change inside `features/search`.
abstract interface class SearchContributor {
  /// A live stream of this feature's current searchable entities. Streamed
  /// (not a one-shot list) so the aggregated index in `searchRegistryProvider`
  /// stays current as the feature's underlying data changes.
  Stream<List<SearchableEntity>> contributions();
}
