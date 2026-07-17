import 'package:drift/native.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/lists/data/repositories/lists_repository.dart';
import 'package:lifeos/features/lists/domain/contracts/lists_summary.dart';
import 'package:lifeos/features/lists/domain/events/list_events.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_notification_contributor.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_search_contributor.dart';

import '../../contracts/feature_contract_test_harness.dart';

/// Follows `notes_feature_contract_test.dart`'s exact shape — the template
/// this feature copied.
void main() {
  runFeatureContractTests<ListsSummary>('Lists', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final eventBus = EventBus();
    final repository = ListsRepository(db.listsDao, eventBus);

    await repository.createList(id: 'l1', title: 'Seed', kind: 'checklist');

    return FeatureContractFixture<ListsSummary>(
      dashboardSummary: () async {
        final lists = await repository.watchAll().first;
        return ListsSummary(
          lists: [
            for (final list in lists)
              ListEntrySummary(
                id: list.id,
                title: list.title,
                subtitle: 'now',
                progress: 0,
              ),
          ],
        );
      },
      searchContributor: ListsSearchContributor(repository),
      notificationContributor: const ListsNotificationContributor(),
      sampleOwnEvent: const ListCreated(listId: 'l1'),
      triggerNotifiableMutation: () =>
          repository.createList(id: 'l2', title: 'Trigger', kind: 'checklist'),
    );
  });
}
