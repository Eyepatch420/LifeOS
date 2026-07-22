import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/hydration/data/repositories/hydration_repository.dart';
import 'package:lifeos/features/hydration/domain/contracts/hydration_dashboard_summary.dart';

final hydrationRepositoryProvider = Provider<HydrationRepository>((ref) {
  return HydrationRepository(
    ref.watch(databaseProvider).hydrationEntriesDao,
    ref.watch(eventBusProvider),
    ref.watch(clockManagerProvider),
    ref.watch(preferencesServiceProvider),
  );
});

/// The Hydration feature's own dashboard provider — the only thing another
/// feature (Health Overview/Home) is allowed to `ref.watch()`. Mirrors
/// `moodDashboardProvider`'s role exactly.
final hydrationDashboardProvider =
    StreamProvider.autoDispose<HydrationDashboardSummary>((ref) {
      final repository = ref.watch(hydrationRepositoryProvider);
      return repository.watchToday().map((todayEntries) {
        final total = todayEntries.fold<int>(0, (sum, e) => sum + e.amountMl);
        return HydrationDashboardSummary(
          todayTotalMl: total,
          goalMl: repository.getGoalMl(),
          recentEntries: [
            for (final entry in todayEntries)
              HydrationEntrySummary(
                id: entry.id,
                amountMl: entry.amountMl,
                recordedAt: entry.recordedAt,
              ),
          ],
        );
      });
    });
