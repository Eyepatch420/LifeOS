import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/medications/data/repositories/medications_repository.dart';
import 'package:lifeos/features/medications/domain/contracts/medications_dashboard_summary.dart';

final medicationsRepositoryProvider = Provider<MedicationsRepository>((ref) {
  return MedicationsRepository(
    ref.watch(databaseProvider).medicationsDao,
    ref.watch(eventBusProvider),
    ref.watch(clockManagerProvider),
  );
});

/// The Medications feature's own dashboard provider — the only thing
/// another feature (Home) is allowed to `ref.watch()`. Home never sees
/// `Medication`/`MedicationsRepository`/`MedicationsDao`, mirroring
/// `habitsDashboardProvider`'s role exactly.
///
/// Uses [MedicationsRepository.todayOccurrencesFor] (not
/// `watchTodayOccurrences()`) inside this `asyncMap` callback — the latter
/// re-queries `watchActive()` itself, and a second independent query issued
/// from inside `watchActive()`'s own stream emission handler deadlocks the
/// underlying Drift connection (observed hanging `app_router_test.dart`'s
/// cross-workspace navigation tests' `pumpAndSettle()` once Health became a
/// real branch — same class of bug `FocusRepository
/// .reconcileNotificationsOnStartup`'s "single query, not two" doc comment
/// documents). Passing the already-fetched `active` list through avoids the
/// second query entirely.
final medicationsDashboardProvider =
    StreamProvider.autoDispose<MedicationsDashboardSummary>((ref) {
      final repository = ref.watch(medicationsRepositoryProvider);
      return repository.watchActive().asyncMap((active) async {
        final occurrences = await repository.todayOccurrencesFor(active);
        final byId = {for (final m in active) m.id: m.name};
        return MedicationsDashboardSummary(
          activeMedicationCount: active.length,
          todayOccurrences: [
            for (final occ in occurrences)
              if (byId[occ.medicationId] != null)
                MedicationOccurrenceSummary(
                  medicationId: occ.medicationId,
                  medicationName: byId[occ.medicationId]!,
                  scheduledFor: occ.scheduledFor,
                  status: occ.status,
                ),
          ],
        );
      });
    });
