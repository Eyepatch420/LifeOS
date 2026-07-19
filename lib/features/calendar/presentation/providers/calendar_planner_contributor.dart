import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/planner/planner_contributor.dart';
import 'package:lifeos/core/planner/planner_item.dart';
import 'package:lifeos/features/calendar/data/repositories/events_repository.dart';
import 'package:lifeos/features/calendar/domain/entities/event.dart';

/// Calendar's contribution to the Planner's cross-feature item stream —
/// registered at `config/di/planner_contributor_registrations.dart`. Every
/// event is already a real stored row (unlike Habits' on-the-fly
/// materialization), so this simply maps `EventsRepository.watchAll()` —
/// `anchor` is unused, same as [RemindersPlannerContributor].
///
/// [PlannerItem.canComplete] is always `false`: an event isn't a task, it's
/// a scheduled block of time — Planner must never render a complete
/// action for one (see [PlannerContributor.complete]'s doc comment).
/// [PlannerItem.temporalKind] mirrors [Event.isAllDay] so `PlannerScreen`
/// can group all-day items separately without a `sourceType` switch.
class CalendarPlannerContributor implements PlannerContributor {
  const CalendarPlannerContributor(this._repository);

  final EventsRepository _repository;

  @override
  PlannerSourceType get sourceType => PlannerSourceType.event;

  @override
  Stream<List<PlannerItem>> contributions(DateTime anchor) {
    return _repository.watchAll().map(
      (events) => events.map(_toPlannerItem).toList(),
    );
  }

  @override
  Future<void> complete(PlannerItem item, {required bool completed}) async {
    // Events are never completable — `PlannerScreen` never calls this for
    // an item with `canComplete: false` (see `PlannerItem.canComplete`'s
    // doc comment), so reaching here would be a caller bug, not a state to
    // silently accept. No-op rather than throwing keeps this contributor
    // total/safe if ever called defensively.
  }

  PlannerItem _toPlannerItem(Event event) {
    return PlannerItem(
      id: 'event:${event.id}',
      sourceType: PlannerSourceType.event,
      sourceId: event.id,
      title: event.title,
      scheduledAt: event.startAt,
      isCompleted: false,
      isUrgent: false,
      isRecurring: false,
      routeName: RouteNames.eventDetail,
      pathParameters: {'eventId': event.id},
      temporalKind: event.isAllDay
          ? PlannerTemporalKind.allDay
          : PlannerTemporalKind.timed,
      canComplete: false,
    );
  }
}
