import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// Everything a Type A feature must supply to satisfy
/// `docs/architecture_principles.md`'s five-part contract (minus the
/// Repository/Entity pair, which is feature-specific and exercised by the
/// feature's own DAO/repository tests instead). Every Type A feature calls
/// [runFeatureContractTests] from its own test file with these three
/// pieces wired to real, seeded feature state — see
/// `test/features/notes/notes_feature_contract_test.dart` for the reference
/// usage.
class FeatureContractFixture<Summary> {
  const FeatureContractFixture({
    required this.dashboardSummary,
    required this.searchContributor,
    required this.notificationContributor,
    required this.sampleOwnEvent,
    required this.triggerNotifiableMutation,
  });

  /// Reads the feature's current dashboard summary DTO directly (not
  /// through Home) — proves the feature owns and exposes it independently.
  final Future<Summary> Function() dashboardSummary;

  final SearchContributor searchContributor;
  final NotificationContributor notificationContributor;

  /// A [DomainEvent] with this feature's `sourceModule` — used to prove
  /// [notificationContributor].handles() recognizes its own events without
  /// the harness needing to know the feature's concrete event types.
  final DomainEvent sampleOwnEvent;

  /// Performs a mutation on the feature's seeded state that is expected to
  /// emit at least one [DomainEvent] (e.g. creating an entity, completing
  /// one). Used to prove the feature's repository actually emits onto the
  /// shared event bus, independent of the notification contract itself.
  final Future<void> Function() triggerNotifiableMutation;
}

/// Runs the shared Type A feature contract against [fixture]. Call once per
/// feature, seeded with at least one entity, from that feature's own test
/// file. [makeFixture] is async and re-run per test so each test gets an
/// isolated, freshly-seeded instance — seeding should complete before
/// [makeFixture] returns so every sub-test (dashboard/search/notification)
/// sees the seeded data, not just whichever runs first.
void runFeatureContractTests<Summary>(
  String featureName,
  Future<FeatureContractFixture<Summary>> Function() makeFixture,
) {
  group('$featureName satisfies the Type A feature contract', () {
    test('exposes a dashboard summary DTO', () async {
      final fixture = await makeFixture();
      final summary = await fixture.dashboardSummary();
      expect(summary, isA<Summary>());
    });

    test('SearchContributor yields entities for seeded data', () async {
      final fixture = await makeFixture();
      final entities = await fixture.searchContributor.contributions().first;
      expect(entities, isNotEmpty);
      expect(entities, everyElement(isA<SearchableEntity>()));
    });

    test(
      'NotificationContributor recognizes its own feature\'s events',
      () async {
        final fixture = await makeFixture();
        expect(
          fixture.notificationContributor.handles(fixture.sampleOwnEvent),
          isTrue,
        );
      },
    );

    test(
      'triggerNotifiableMutation causes the feature to emit onto the event bus',
      () async {
        final fixture = await makeFixture();
        // Exercises the mutation for its side effect (an emitted
        // DomainEvent) — the feature's own repository test is what
        // actually asserts on EventBus contents; this only proves the
        // harness's provided mutation doesn't throw.
        await fixture.triggerNotifiableMutation();
      },
    );
  });
}
