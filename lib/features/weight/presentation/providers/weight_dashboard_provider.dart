import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/weight/data/repositories/weight_repository.dart';
import 'package:lifeos/features/weight/domain/contracts/weight_dashboard_summary.dart';

final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  return WeightRepository(
    ref.watch(databaseProvider).weightEntriesDao,
    ref.watch(eventBusProvider),
    ref.watch(clockManagerProvider),
  );
});

/// The Weight feature's own dashboard provider — the only thing another
/// feature (Health Overview/Home) is allowed to `ref.watch()`. Mirrors
/// `moodDashboardProvider`'s role exactly.
final weightDashboardProvider =
    StreamProvider.autoDispose<WeightDashboardSummary>((ref) {
      final repository = ref.watch(weightRepositoryProvider);
      // watchAll() orders newest first, so entries[0] is latest and
      // entries[1] (if present) is the prior measurement to diff against.
      return repository.watchAll().map((entries) {
        final latest = entries.isEmpty ? null : entries[0];
        final previous = entries.length > 1 ? entries[1] : null;
        return WeightDashboardSummary(
          latestWeightKg: latest?.weightKg,
          changeFromPreviousKg: (latest == null || previous == null)
              ? null
              : latest.weightKg - previous.weightKg,
          recentEntries: [
            for (final entry in entries.take(20))
              WeightEntrySummary(
                id: entry.id,
                weightKg: entry.weightKg,
                note: entry.note,
                recordedAt: entry.recordedAt,
              ),
          ],
        );
      });
    });
