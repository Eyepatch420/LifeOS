import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/home/data/mock_dashboard_data.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/features/home/domain/models/home_section_config.dart';
import 'package:lifeos/features/home/presentation/providers/home_section_registry.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_dashboard_provider.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';

/// Each Home section's data is an `AsyncNotifier<List<T>>`, not a plain
/// synchronous `Provider`, even though `build()` currently just returns a
/// mock const. This means "loading" (`AsyncLoading`), "empty" (`AsyncData(
/// [])`), and "error" (`AsyncError`) all fall out of Riverpod's existing
/// `AsyncValue` machinery for free — no parallel state-union type invented
/// — and swapping in a real repository call later is purely a `build()`
/// body change, no call-site changes anywhere (see docs/architecture.md).
class OverviewStatsNotifier extends AsyncNotifier<List<OverviewStat>> {
  @override
  Future<List<OverviewStat>> build() async => kOverviewStats;
}

final overviewStatsProvider =
    AsyncNotifierProvider<OverviewStatsNotifier, List<OverviewStat>>(
      OverviewStatsNotifier.new,
    );

class QuickActionsNotifier extends AsyncNotifier<List<QuickAction>> {
  @override
  Future<List<QuickAction>> build() async => kQuickActions;
}

final quickActionsProvider =
    AsyncNotifierProvider<QuickActionsNotifier, List<QuickAction>>(
      QuickActionsNotifier.new,
    );

class UpNextNotifier extends AsyncNotifier<List<UpNextItem>> {
  @override
  Future<List<UpNextItem>> build() async => kUpNext;

  void dismiss(String id) {
    state = AsyncData([
      for (final item in state.value ?? <UpNextItem>[])
        if (item.id != id) item,
    ]);
  }
}

final upNextProvider = AsyncNotifierProvider<UpNextNotifier, List<UpNextItem>>(
  UpNextNotifier.new,
);

class HabitStreaksNotifier extends AsyncNotifier<List<HabitStreak>> {
  @override
  Future<List<HabitStreak>> build() async => kHabitStreaks;
}

final habitStreaksProvider =
    AsyncNotifierProvider<HabitStreaksNotifier, List<HabitStreak>>(
      HabitStreaksNotifier.new,
    );

class TimelineNotifier extends AsyncNotifier<List<TimelineStep>> {
  @override
  Future<List<TimelineStep>> build() async => kTimeline;

  void dismiss(String id) {
    state = AsyncData([
      for (final step in state.value ?? <TimelineStep>[])
        if (step.id != id) step,
    ]);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineNotifier, List<TimelineStep>>(
      TimelineNotifier.new,
    );

/// A thin watch of the Notes feature's own `notesDashboardProvider` — Home
/// never imports `Note`, `NotesRepository`, or anything else from
/// `features/notes` beyond this one dashboard summary provider (see
/// docs/architecture_principles.md's Architecture Constraint 1). Maps
/// `RecentNotesSummary` to the existing `NoteSummary` card model so
/// `RecentNotesCard` and every other call site is unchanged.
class RecentNotesNotifier extends AsyncNotifier<List<NoteSummary>> {
  @override
  Future<List<NoteSummary>> build() async {
    final summary = await ref.watch(notesDashboardProvider.future);
    return [
      for (final note in summary.notes)
        NoteSummary(
          id: note.id,
          icon: Icons.note_alt_outlined,
          title: note.title,
          preview: note.preview,
          timestamp: note.timestamp,
          isPinned: note.isPinned,
        ),
    ];
  }
}

final recentNotesProvider =
    AsyncNotifierProvider<RecentNotesNotifier, List<NoteSummary>>(
      RecentNotesNotifier.new,
    );

/// Same thin-watch shape as [RecentNotesNotifier], for `features/lists`.
class MyListsNotifier extends AsyncNotifier<List<ListSummary>> {
  @override
  Future<List<ListSummary>> build() async {
    final summary = await ref.watch(listsDashboardProvider.future);
    return [
      for (final list in summary.lists)
        ListSummary(
          id: list.id,
          icon: Icons.checklist_outlined,
          title: list.title,
          subtitle: list.subtitle,
          progress: list.progress,
        ),
    ];
  }
}

final myListsProvider =
    AsyncNotifierProvider<MyListsNotifier, List<ListSummary>>(
      MyListsNotifier.new,
    );

/// Not a section (no visibility/order/empty-state concept) — just the
/// Hero's rotating message content.
final motivationalMessageProvider = Provider<String>(
  (ref) => kMotivationalMessage,
);

/// Order + visibility for the 7 Home sections. No settings UI writes to
/// this yet, but a future one is a one-line
/// `.reorder([...])`/`.setVisible(id, false)` call — `HomeScreen` renders
/// whatever this holds with zero code change (see docs/architecture.md).
class HomeSectionsNotifier extends Notifier<List<HomeSectionMeta>> {
  @override
  List<HomeSectionMeta> build() => kDefaultHomeSections;

  void reorder(List<String> newIdOrder) {
    state = [
      for (final id in newIdOrder)
        state
            .firstWhere((s) => s.id == id)
            .copyWith(order: newIdOrder.indexOf(id)),
    ];
  }

  void setVisible(String id, bool visible) {
    state = [
      for (final section in state)
        if (section.id == id) section.copyWith(visible: visible) else section,
    ];
  }
}

final homeSectionsProvider =
    NotifierProvider<HomeSectionsNotifier, List<HomeSectionMeta>>(
      HomeSectionsNotifier.new,
    );

/// Ticks once a minute so the Home hero's time-of-day tint/greeting stay
/// current during a long-lived session without requiring a manual refresh.
final clockTickProvider = StreamProvider<DateTime>((ref) {
  return Stream<DateTime>.periodic(
    const Duration(minutes: 1),
    (_) => DateTime.now(),
  ).startWith(DateTime.now());
});

extension<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
