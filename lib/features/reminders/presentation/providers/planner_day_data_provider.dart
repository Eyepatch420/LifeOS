import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/planner_contributor_registrations.dart';
import 'package:lifeos/core/planner/planner_item.dart';
import 'package:lifeos/features/reminders/domain/planner/planner_day_data.dart';
import 'package:lifeos/features/reminders/presentation/providers/planner_selected_date_provider.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_data_provider.dart';

/// The flat, live [PlannerItem] projection Planner derives everything from
/// — merges every registered [PlannerContributor] (Reminders, Habits,
/// Calendar as of Phase 7) via `plannerContributors`, the same
/// composition-layer seam `agendaContributors`/`searchContributors`/
/// `notificationContributors` use. `PlannerScreen`/[plannerDayDataProvider]
/// never need to change when a new contributor is registered, since they
/// only ever see `List<PlannerItem>`. `autoDispose` for the same reason as
/// [remindersClockTickProvider] (see that provider's doc comment): avoids
/// timers/streams outliving a test or an unmounted Planner screen.
///
/// Re-watches [plannerSelectedDateProvider] and passes it as each
/// contributor's `anchor` (see [PlannerContributor.contributions]'s doc
/// comment) — this provider re-subscribes to every contributor whenever the
/// selected date changes, which is exactly what lets
/// `HabitsPlannerContributor` re-center its materialization window on
/// wherever the user actually navigated to (Phase 7's fix for the Phase 6
/// ±30-day-from-today limitation).
final _plannerItemsProvider = StreamProvider.autoDispose<List<PlannerItem>>((
  ref,
) {
  final contributors = ref.watch(plannerContributorsProvider);
  final anchor = ref.watch(plannerSelectedDateProvider);
  final streams = [for (final c in contributors) c.contributions(anchor)];
  if (streams.isEmpty) return Stream.value(const <PlannerItem>[]);
  return _mergeContributorStreams(streams);
});

/// Combines N contributors' live streams into one, re-emitting the full
/// merged list whenever any single contributor updates — mirrors
/// `AgendaRegistry.watchAll`'s merge shape, just kept local here since
/// Planner (unlike Agenda) doesn't need a standalone registry class for a
/// single call site.
Stream<List<PlannerItem>> _mergeContributorStreams(
  List<Stream<List<PlannerItem>>> streams,
) {
  final latest = List<List<PlannerItem>>.filled(streams.length, const []);
  final received = List<bool>.filled(streams.length, false);

  return Stream.multi((controller) {
    final subs = <StreamSubscription<List<PlannerItem>>>[];
    for (var i = 0; i < streams.length; i++) {
      subs.add(
        streams[i].listen((items) {
          latest[i] = items;
          received[i] = true;
          if (received.every((r) => r)) {
            controller.add([for (final list in latest) ...list]);
          }
        }, onError: controller.addError),
      );
    }
    controller.onCancel = () async {
      for (final sub in subs) {
        await sub.cancel();
      }
    };
  });
}

/// The Planner's derived presentation state for the currently selected
/// day: reclassifies [_plannerItemsProvider]'s live stream via
/// [plannerDayFor] whenever the underlying data changes, the minute ticks
/// over (reusing [remindersClockTickProvider] — Today/overdue-carryover
/// semantics are time-sensitive the same way the Reminders dashboard's
/// are), or [plannerSelectedDateProvider] changes. Pure derivation only;
/// classification logic lives in [plannerDayFor] and is independently unit
/// tested. `autoDispose` for the same reason as its inputs.
final plannerDayDataProvider = Provider.autoDispose<AsyncValue<PlannerDayData>>(
  (ref) {
    final itemsAsync = ref.watch(_plannerItemsProvider);
    final nowAsync = ref.watch(remindersClockTickProvider);
    final selectedDate = ref.watch(plannerSelectedDateProvider);

    return itemsAsync.when(
      data: (items) => nowAsync.when(
        data: (now) =>
            AsyncData(plannerDayFor(items, date: selectedDate, now: now)),
        loading: () => const AsyncLoading(),
        error: AsyncError.new,
      ),
      loading: () => const AsyncLoading(),
      error: AsyncError.new,
    );
  },
);
