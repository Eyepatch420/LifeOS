import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/sleep/data/repositories/sleep_repository.dart';
import 'package:lifeos/features/sleep/domain/contracts/sleep_dashboard_summary.dart';
import 'package:lifeos/features/sleep/domain/entities/sleep_quality.dart';

final sleepRepositoryProvider = Provider<SleepRepository>((ref) {
  return SleepRepository(
    ref.watch(databaseProvider).sleepEntriesDao,
    ref.watch(eventBusProvider),
    ref.watch(clockManagerProvider),
  );
});

/// The Sleep feature's own dashboard provider — the only thing another
/// feature (Health Overview/Home) is allowed to `ref.watch()`. Mirrors
/// `moodDashboardProvider`'s role exactly.
final sleepDashboardProvider =
    StreamProvider.autoDispose<SleepDashboardSummary>((ref) {
      final repository = ref.watch(sleepRepositoryProvider);
      return repository.watchAll().map((entries) {
        final latest = entries.isEmpty ? null : entries.first;
        return SleepDashboardSummary(
          latestDuration: latest?.duration,
          latestQualityLabel: latest?.quality?.label,
          recentEntries: [
            for (final entry in entries.take(14))
              SleepEntrySummary(
                id: entry.id,
                bedtime: entry.bedtime,
                wakeTime: entry.wakeTime,
                duration: entry.duration,
                qualityLabel: entry.quality?.label,
              ),
          ],
        );
      });
    });
