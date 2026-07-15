import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/home/data/mock_dashboard_data.dart';
import 'package:lifeos/features/home/presentation/providers/home_providers.dart';
import 'package:lifeos/features/home/presentation/providers/home_section_registry.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test(
    'each section AsyncNotifier resolves to its expected mock list',
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
      expect(await container.read(recentNotesProvider.future), kRecentNotes);
      expect(await container.read(myListsProvider.future), kMyLists);
    },
  );

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
}
