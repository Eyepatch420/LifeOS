import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/home/data/mock_dashboard_data.dart';
import 'package:lifeos/features/home/presentation/providers/home_providers.dart';
import 'package:lifeos/features/home/presentation/providers/home_section_registry.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_dashboard_provider.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test(
    'each still-mock-backed section AsyncNotifier resolves to its expected mock list',
    () async {
      final container = makeContainer();

      expect(
        await container.read(overviewStatsProvider.future),
        kOverviewStats,
      );
      expect(await container.read(quickActionsProvider.future), kQuickActions);
      expect(await container.read(upNextProvider.future), kUpNext);
      expect(await container.read(habitStreaksProvider.future), kHabitStreaks);
      expect(await container.read(timelineProvider.future), kTimeline);
    },
  );

  test(
    'recentNotesProvider is a thin watch of notesDashboardProvider',
    () async {
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
      // recentNotesProvider/notesDashboardProvider default to auto-dispose
      // (Riverpod 3.x) — a plain container.read(...future) with no active
      // listener races the underlying StreamProvider's own disposal after
      // the synchronous portion of read() returns, before the stream's
      // first event arrives. Hold a listener open for the read's lifetime,
      // same pattern documented in implemented_features.md.
      final sub = container.listen(recentNotesProvider, (_, _) {});
      addTearDown(sub.close);

      await container
          .read(notesRepositoryProvider)
          .create(id: 'n1', title: 'Groceries', body: 'Milk, eggs');

      final notes = await container.read(recentNotesProvider.future);
      expect(notes, hasLength(1));
      expect(notes.single.title, 'Groceries');
    },
  );

  test('myListsProvider is a thin watch of listsDashboardProvider', () async {
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
    final sub = container.listen(myListsProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(listsRepositoryProvider)
        .createList(id: 'l1', title: 'Weekend Trip', kind: 'checklist');

    final lists = await container.read(myListsProvider.future);
    expect(lists, hasLength(1));
    expect(lists.single.title, 'Weekend Trip');
  });

  test('motivationalMessageProvider returns kMotivationalMessage', () {
    final container = makeContainer();
    expect(container.read(motivationalMessageProvider), kMotivationalMessage);
  });

  test('homeSectionsProvider defaults to kDefaultHomeSections', () {
    final container = makeContainer();
    final sections = container.read(homeSectionsProvider);

    expect(sections, kDefaultHomeSections);
    expect(sections.every((s) => s.visible), isTrue);
  });

  test("setVisible flips one section's visible without affecting others", () {
    final container = makeContainer();

    container
        .read(homeSectionsProvider.notifier)
        .setVisible(HomeSectionIds.timeline, false);

    final sections = container.read(homeSectionsProvider);
    final timeline = sections.firstWhere(
      (s) => s.id == HomeSectionIds.timeline,
    );
    final others = sections.where((s) => s.id != HomeSectionIds.timeline);

    expect(timeline.visible, isFalse);
    expect(others.every((s) => s.visible), isTrue);
    // order is untouched by setVisible.
    expect(
      timeline.order,
      kDefaultHomeSections
          .firstWhere((s) => s.id == HomeSectionIds.timeline)
          .order,
    );
  });

  test(
    'reorder reassigns order for the given ids without affecting visible',
    () {
      final container = makeContainer();

      container.read(homeSectionsProvider.notifier).reorder([
        HomeSectionIds.timeline,
        HomeSectionIds.overview,
        HomeSectionIds.quickActions,
        HomeSectionIds.upNextAndHabits,
        HomeSectionIds.notesAndLists,
      ]);

      final sections = container.read(homeSectionsProvider);
      final timeline = sections.firstWhere(
        (s) => s.id == HomeSectionIds.timeline,
      );
      final overview = sections.firstWhere(
        (s) => s.id == HomeSectionIds.overview,
      );

      expect(timeline.order, 0);
      expect(overview.order, 1);
      expect(sections.every((s) => s.visible), isTrue);
    },
  );

  test('kDefaultHomeSections defaults enabled=true, collapsed=false, and '
      'priority matching order', () {
    for (final section in kDefaultHomeSections) {
      expect(section.enabled, isTrue);
      expect(section.collapsed, isFalse);
      expect(section.priority, section.order);
    }
  });

  test("UpNextNotifier.dismiss removes only the matching item's id", () async {
    final container = makeContainer();
    await container.read(upNextProvider.future);

    final target = kUpNext.first;
    container.read(upNextProvider.notifier).dismiss(target.id);

    final remaining = container.read(upNextProvider).value!;
    expect(remaining.any((i) => i.id == target.id), isFalse);
    expect(remaining.length, kUpNext.length - 1);
  });

  test(
    "TimelineNotifier.dismiss removes only the matching step's id",
    () async {
      final container = makeContainer();
      await container.read(timelineProvider.future);

      final target = kTimeline.first;
      container.read(timelineProvider.notifier).dismiss(target.id);

      final remaining = container.read(timelineProvider).value!;
      expect(remaining.any((s) => s.id == target.id), isFalse);
      expect(remaining.length, kTimeline.length - 1);
    },
  );
}
