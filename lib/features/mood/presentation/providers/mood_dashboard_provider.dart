import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/mood/data/repositories/mood_repository.dart';
import 'package:lifeos/features/mood/domain/contracts/mood_dashboard_summary.dart';
import 'package:lifeos/features/mood/domain/entities/mood_level.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository(
    ref.watch(databaseProvider).moodEntriesDao,
    ref.watch(eventBusProvider),
    ref.watch(clockManagerProvider),
  );
});

/// The Mood feature's own dashboard provider — the only thing another
/// feature (Home) is allowed to `ref.watch()`. Home never sees
/// `MoodEntry`/`MoodRepository`/`MoodEntriesDao`, mirroring
/// `habitsDashboardProvider`'s role exactly.
final moodDashboardProvider = StreamProvider.autoDispose<MoodDashboardSummary>((
  ref,
) {
  final repository = ref.watch(moodRepositoryProvider);
  final clock = ref.watch(clockManagerProvider);
  return repository.watchAll().map((entries) {
    final today = dateOnly(clock.now());
    final todayEntries = entries
        .where((e) => isSameDay(e.recordedAt, today))
        .toList();
    // watchAll() already orders by recordedAt desc, so the first
    // today-entry (if any) is the most recent.
    final latestToday = todayEntries.isEmpty ? null : todayEntries.first;

    return MoodDashboardSummary(
      todayLevelLabel: latestToday?.level.label,
      todayEntryCount: todayEntries.length,
      recentEntries: [
        for (final entry in entries.take(10))
          MoodEntrySummary(
            id: entry.id,
            levelLabel: entry.level.label,
            levelEmoji: entry.level.emoji,
            note: entry.note,
            recordedAt: entry.recordedAt,
          ),
      ],
    );
  });
});
