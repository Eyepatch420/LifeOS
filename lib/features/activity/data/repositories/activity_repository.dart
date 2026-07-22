import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/constants/pref_keys.dart';
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/daily_activity_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/activity/domain/entities/daily_activity_entry.dart';
import 'package:lifeos/features/activity/domain/events/activity_events.dart';
import 'package:lifeos/services/preferences_service.dart';

/// Default daily step goal shown before the user has ever set one.
const int kDefaultActivityGoalSteps = 10000;

/// The single owner of Activity persistence — every mutation/query goes
/// through here, wrapping [DailyActivityDao] and mapping Drift rows to the
/// feature's own [DailyActivityEntry] entity. No other feature imports this
/// class or [DailyActivityDao] directly (Golden Rule, mirrors
/// `MoodRepository`).
///
/// Unlike Hydration/Sleep/Weight, Activity is upsert-by-day, not
/// append-only — [setTodaySteps] overwrites the current local day's row in
/// place rather than adding a new record, matching `DailyActivity`'s table
/// doc comment.
///
/// Also owns the daily step goal — a simple persisted preference via
/// [PreferencesService], deliberately not a database row: it's
/// configuration, not history (see `PrefKeys.activityDailyGoalSteps`).
///
/// Emits [ActivityUpdated] onto the shared [EventBus] for every upsert —
/// never calls `NotificationScheduler` directly. Activity deliberately has
/// no [NotificationContributor] (nothing to schedule this phase).
///
/// All "now"/"today" values come from [ClockManager], not `DateTime.now()`
/// directly, so tests can drive the timeline with a fake clock.
class ActivityRepository {
  ActivityRepository(this._dao, this._eventBus, this._clock, this._prefs);

  final DailyActivityDao _dao;
  final EventBus _eventBus;
  final ClockManager _clock;
  final PreferencesService _prefs;

  static String dayKeyFor(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Most recent [limit] days, newest first.
  Stream<List<DailyActivityEntry>> watchRecent(int limit) {
    return _dao.watchRecent(limit).map((rows) => rows.map(_toEntity).toList());
  }

  Stream<DailyActivityEntry?> watchToday() {
    final todayKey = dayKeyFor(_clock.now());
    return watchRecent(1).map(
      (days) =>
          days.isEmpty || days.first.dayKey != todayKey ? null : days.first,
    );
  }

  /// Rejects negative steps — a zero step count is a legitimate "haven't
  /// moved yet today" value, but a negative one is always a mistake.
  Future<void> setTodaySteps({
    required int steps,
    int? distanceMeters,
    int? activeMinutes,
  }) async {
    if (steps < 0) {
      throw ArgumentError.value(steps, 'steps', 'must not be negative');
    }
    final todayKey = dayKeyFor(_clock.now());
    await _dao.upsert(
      db.DailyActivityCompanion.insert(
        id: todayKey,
        steps: steps,
        distanceMeters: Value(distanceMeters),
        activeMinutes: Value(activeMinutes),
        updatedAt: _clock.now(),
      ),
    );
    _eventBus.emit(ActivityUpdated(dayKey: todayKey));
  }

  int getGoalSteps() =>
      _prefs.getInt(PrefKeys.activityDailyGoalSteps) ??
      kDefaultActivityGoalSteps;

  Future<void> setGoalSteps(int goalSteps) async {
    if (goalSteps <= 0) {
      throw ArgumentError.value(goalSteps, 'goalSteps', 'must be positive');
    }
    await _prefs.setInt(PrefKeys.activityDailyGoalSteps, goalSteps);
  }

  DailyActivityEntry _toEntity(db.DailyActivityData row) => DailyActivityEntry(
    dayKey: row.id,
    steps: row.steps,
    distanceMeters: row.distanceMeters,
    activeMinutes: row.activeMinutes,
    updatedAt: row.updatedAt,
  );
}
