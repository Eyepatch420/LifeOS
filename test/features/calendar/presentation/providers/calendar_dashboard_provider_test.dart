import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_dashboard_provider.dart';

void main() {
  Future<ProviderContainer> makeContainer() async {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    return container;
  }

  test('zero events yields an empty summary', () async {
    final container = await makeContainer();
    final sub = container.listen(calendarDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    final summary = await container.read(calendarDashboardProvider.future);
    expect(summary.upcoming, isEmpty);
    expect(summary.todayCount, 0);
  });

  test('a future event is included in upcoming', () async {
    final container = await makeContainer();
    final sub = container.listen(calendarDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(eventsRepositoryProvider)
        .create(
          id: 'e1',
          title: 'Standup',
          startAt: DateTime.now().add(const Duration(hours: 1)),
          isAllDay: false,
        );

    final summary = await container.read(calendarDashboardProvider.future);
    expect(summary.upcoming, hasLength(1));
    expect(summary.upcoming.single.title, 'Standup');
  });

  test('a past event is excluded from upcoming', () async {
    final container = await makeContainer();
    final sub = container.listen(calendarDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(eventsRepositoryProvider)
        .create(
          id: 'e1',
          title: 'Yesterday',
          startAt: DateTime.now().subtract(const Duration(days: 1)),
          isAllDay: false,
        );

    final summary = await container.read(calendarDashboardProvider.future);
    expect(summary.upcoming, isEmpty);
  });

  test('todayCount counts only events starting today', () async {
    final container = await makeContainer();
    final sub = container.listen(calendarDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    final now = DateTime.now();
    final repository = container.read(eventsRepositoryProvider);
    await repository.create(
      id: 'e1',
      title: 'Today',
      startAt: DateTime(now.year, now.month, now.day, 15),
      isAllDay: false,
    );
    await repository.create(
      id: 'e2',
      title: 'Tomorrow',
      startAt: now.add(const Duration(days: 1)),
      isAllDay: false,
    );

    final summary = await container.read(calendarDashboardProvider.future);
    expect(summary.todayCount, 1);
  });

  test('repository changes update the provider output reactively', () async {
    final container = await makeContainer();
    final sub = container.listen(calendarDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    await container.read(calendarDashboardProvider.future);
    final repository = container.read(eventsRepositoryProvider);

    await repository.create(
      id: 'e1',
      title: 'New',
      startAt: DateTime.now().add(const Duration(hours: 2)),
      isAllDay: false,
    );

    await Future<void>.delayed(Duration.zero);
    final summary = await container.read(calendarDashboardProvider.future);
    expect(summary.upcoming, hasLength(1));
  });
}
