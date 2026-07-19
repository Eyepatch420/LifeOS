import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_dashboard_provider.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/features/home/data/mock_dashboard_data.dart';
import 'package:lifeos/features/home/presentation/providers/home_providers.dart';
import 'package:lifeos/features/home/presentation/providers/home_section_registry.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_dashboard_provider.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';

ProviderContainer _makeDbBackedContainer() {
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

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test(
    'still-mock-backed section AsyncNotifiers resolve to their expected mock list',
    () async {
      final container = makeContainer();

      expect(
        await container.read(overviewStatsProvider.future),
        kOverviewStats,
      );
      expect(await container.read(quickActionsProvider.future), kQuickActions);
    },
  );

  test('upNextProvider is a thin watch of agendaEntriesProvider (Reminders + '
      'Calendar merged) — no longer mock-backed as of Phase 7', () async {
    final container = _makeDbBackedContainer();
    final sub = container.listen(upNextProvider, (_, _) {});
    addTearDown(sub.close);
    // upNextProvider's first `.future` resolution reflects
    // agendaEntriesProvider's state at listen-time, before either
    // repository write below lands — awaiting the future again after
    // each mutation re-reads the latest state once the merged Agenda
    // stream re-emits (same "not autoDispose, so the initial build()
    // snapshot doesn't itself re-await later mutations" reasoning as
    // AsyncNotifier's documented pattern elsewhere in this file).
    await container.read(upNextProvider.future);

    await container
        .read(remindersRepositoryProvider)
        .create(
          id: 'r1',
          title: 'Pay rent',
          dueAt: DateTime.now().add(const Duration(hours: 1)),
          isUrgent: false,
        );
    await pumpEventQueue();
    await container
        .read(eventsRepositoryProvider)
        .create(
          id: 'e1',
          title: 'Standup',
          startAt: DateTime.now().add(const Duration(hours: 2)),
          isAllDay: false,
        );
    await pumpEventQueue();

    final items = container.read(upNextProvider).value!;
    expect(items.map((i) => i.title), containsAll(['Pay rent', 'Standup']));
  });

  test('timelineProvider is a thin watch of agendaEntriesProvider', () async {
    final container = _makeDbBackedContainer();
    final sub = container.listen(timelineProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(timelineProvider.future);

    await container
        .read(eventsRepositoryProvider)
        .create(
          id: 'e1',
          title: 'Conference',
          startAt: DateTime.now(),
          isAllDay: true,
        );
    await pumpEventQueue();

    final steps = container.read(timelineProvider).value!;
    expect(steps, hasLength(1));
    expect(steps.single.label, 'Conference');
    expect(steps.single.time, 'All day');
  });

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

  test(
    'habitStreaksProvider is a thin watch of habitsDashboardProvider',
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
      final sub = container.listen(habitStreaksProvider, (_, _) {});
      addTearDown(sub.close);

      await container
          .read(habitsRepositoryProvider)
          .create(
            id: 'h1',
            title: 'Morning Walk',
            schedule: const HabitSchedule.daily(),
            icon: 'walk',
          );

      final streaks = await container.read(habitStreaksProvider.future);
      expect(streaks, hasLength(1));
      expect(streaks.single.title, 'Morning Walk');
      expect(streaks.single.id, 'h1');
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
    final container = _makeDbBackedContainer();
    final sub = container.listen(upNextProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(upNextProvider.future);

    await container
        .read(remindersRepositoryProvider)
        .create(
          id: 'r1',
          title: 'Pay rent',
          dueAt: DateTime.now().add(const Duration(hours: 1)),
          isUrgent: false,
        );
    await pumpEventQueue();
    await container
        .read(remindersRepositoryProvider)
        .create(
          id: 'r2',
          title: 'Call mom',
          dueAt: DateTime.now().add(const Duration(hours: 2)),
          isUrgent: false,
        );
    await pumpEventQueue();

    final before = container.read(upNextProvider).value!;
    expect(before, hasLength(2));

    container.read(upNextProvider.notifier).dismiss(before.first.id);

    final remaining = container.read(upNextProvider).value!;
    expect(remaining.any((i) => i.id == before.first.id), isFalse);
    expect(remaining.length, 1);
  });

  test(
    "TimelineNotifier.dismiss removes only the matching step's id",
    () async {
      final container = _makeDbBackedContainer();
      final sub = container.listen(timelineProvider, (_, _) {});
      addTearDown(sub.close);
      await container.read(timelineProvider.future);

      await container
          .read(eventsRepositoryProvider)
          .create(
            id: 'e1',
            title: 'Standup',
            startAt: DateTime.now().add(const Duration(hours: 1)),
            isAllDay: false,
          );
      await pumpEventQueue();
      await container
          .read(eventsRepositoryProvider)
          .create(
            id: 'e2',
            title: 'Review',
            startAt: DateTime.now().add(const Duration(hours: 2)),
            isAllDay: false,
          );
      await pumpEventQueue();

      final before = container.read(timelineProvider).value!;
      expect(before, hasLength(2));

      container.read(timelineProvider.notifier).dismiss(before.first.id);

      final remaining = container.read(timelineProvider).value!;
      expect(remaining.any((s) => s.id == before.first.id), isFalse);
      expect(remaining.length, 1);
    },
  );
}
