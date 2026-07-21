import 'package:flutter/material.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

import 'feature_contract_test_harness.dart';

class _FakeSummary {
  const _FakeSummary(this.count);
  final int count;
}

class _FakeEvent extends DomainEvent {
  const _FakeEvent() : super(sourceModule: 'fake', sourceId: 'f1');
}

class _FakeSearchContributor implements SearchContributor {
  @override
  Stream<List<SearchableEntity>> contributions() => Stream.value(const [
    SearchableEntity(
      id: 'fake-1',
      title: 'Fake entity',
      subtitle: 'For harness self-test',
      icon: Icons.circle,
      category: SearchableEntityCategory.note,
      routeName: 'fake',
    ),
  ]);
}

class _FakeNotificationContributor implements NotificationContributor {
  bool triggered = false;

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'fake';

  @override
  List<NotificationIntent> map(DomainEvent event) => const [];
}

void main() {
  runFeatureContractTests<_FakeSummary>(
    'FakeFeature (harness self-test)',
    () async {
      final notificationContributor = _FakeNotificationContributor();
      return FeatureContractFixture<_FakeSummary>(
        dashboardSummary: () async => const _FakeSummary(1),
        searchContributor: _FakeSearchContributor(),
        notificationContributor: notificationContributor,
        sampleOwnEvent: const _FakeEvent(),
        triggerNotifiableMutation: () async =>
            notificationContributor.triggered = true,
      );
    },
  );
}
