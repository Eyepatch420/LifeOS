import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/lists/data/repositories/lists_repository.dart';
import 'package:lifeos/features/lists/domain/contracts/lists_summary.dart';

final listsRepositoryProvider = Provider<ListsRepository>((ref) {
  return ListsRepository(
    ref.watch(databaseProvider).listsDao,
    ref.watch(eventBusProvider),
  );
});

/// The Lists feature's own dashboard provider — the only thing another
/// feature (Home) is allowed to `ref.watch()`. Maps the repository's
/// `TodoList` stream to [ListsSummary] (progress-only), keeping the 5 most
/// recent lists. Home never sees `TodoList` or `ListsRepository`.
final listsDashboardProvider = StreamProvider<ListsSummary>((ref) {
  return ref.watch(listsRepositoryProvider).watchAll().map((lists) {
    return ListsSummary(
      lists: [
        for (final list in lists.take(5))
          ListEntrySummary(
            id: list.id,
            title: list.title,
            subtitle: list.items.isEmpty
                ? 'No items yet'
                : '${list.items.where((i) => i.isDone).length}/${list.items.length} done',
            progress: list.items.isEmpty
                ? 0
                : list.items.where((i) => i.isDone).length / list.items.length,
          ),
      ],
    );
  });
});
