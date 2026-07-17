import 'dart:async';

import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// Combines every registered [SearchContributor] into one live index.
/// Contributors are registered at the composition layer
/// (`config/di/search_contributor_registrations.dart`), not imported here —
/// this class never references a feature's types, so adding a new
/// searchable feature is a registration-only change.
class SearchRegistry {
  SearchRegistry(this._contributors);

  final List<SearchContributor> _contributors;

  /// The merged, live index across every registered contributor. Combines
  /// each contributor's stream into one list that updates whenever any
  /// single contributor's data changes.
  Stream<List<SearchableEntity>> watchAll() {
    if (_contributors.isEmpty) return Stream.value(const []);

    final latest = List<List<SearchableEntity>>.filled(
      _contributors.length,
      const [],
    );
    final controller = StreamController<List<SearchableEntity>>.broadcast();
    final subscriptions = <StreamSubscription<List<SearchableEntity>>>[];
    var receivedCount = 0;
    final received = List<bool>.filled(_contributors.length, false);

    void emit() {
      controller.add([for (final entities in latest) ...entities]);
    }

    controller.onListen = () {
      for (var i = 0; i < _contributors.length; i++) {
        final index = i;
        subscriptions.add(
          _contributors[index].contributions().listen((entities) {
            latest[index] = entities;
            if (!received[index]) {
              received[index] = true;
              receivedCount++;
            }
            if (receivedCount == _contributors.length) emit();
          }),
        );
      }
    };
    controller.onCancel = () async {
      for (final sub in subscriptions) {
        await sub.cancel();
      }
      await controller.close();
    };

    return controller.stream;
  }
}
