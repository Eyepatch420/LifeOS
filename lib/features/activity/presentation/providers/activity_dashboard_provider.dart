import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/activity/data/repositories/activity_repository.dart';
import 'package:lifeos/features/activity/domain/contracts/activity_dashboard_summary.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository(
    ref.watch(databaseProvider).dailyActivityDao,
    ref.watch(eventBusProvider),
    ref.watch(clockManagerProvider),
    ref.watch(preferencesServiceProvider),
  );
});

/// The Activity feature's own dashboard provider — the only thing another
/// feature (Health Overview/Home) is allowed to `ref.watch()`. Mirrors
/// `moodDashboardProvider`'s role exactly.
final activityDashboardProvider =
    StreamProvider.autoDispose<ActivityDashboardSummary>((ref) {
      final repository = ref.watch(activityRepositoryProvider);
      final clock = ref.watch(clockManagerProvider);
      final goal = repository.getGoalSteps();
      final todayKey = ActivityRepository.dayKeyFor(clock.now());
      return repository.watchRecent(7).map((days) {
        final today = days.where((d) => d.dayKey == todayKey).firstOrNull;
        return ActivityDashboardSummary(
          todaySteps: today?.steps ?? 0,
          goalSteps: goal,
          recentDays: [
            for (final day in days)
              DailyActivitySummary(
                dayKey: day.dayKey,
                steps: day.steps,
                goalSteps: goal,
              ),
          ],
        );
      });
    });
