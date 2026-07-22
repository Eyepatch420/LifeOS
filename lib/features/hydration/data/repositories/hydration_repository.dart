import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/constants/pref_keys.dart';
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/hydration_entries_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/hydration/domain/entities/hydration_entry.dart';
import 'package:lifeos/features/hydration/domain/events/hydration_events.dart';
import 'package:lifeos/services/preferences_service.dart';

/// Default daily goal shown before the user has ever set one — a reasonable
/// starting point (roughly the commonly cited 8x250ml "8 glasses a day"),
/// never silently persisted until the user actually changes it.
const int kDefaultHydrationGoalMl = 2500;

/// The single owner of Hydration persistence — every mutation/query goes
/// through here, wrapping [HydrationEntriesDao] and mapping Drift rows to
/// the feature's own [HydrationEntry] entity. No other feature imports this
/// class or [HydrationEntriesDao] directly (Golden Rule, mirrors
/// `MoodRepository`).
///
/// Also owns the daily goal — a simple persisted preference via
/// [PreferencesService], deliberately not a database row: it's
/// configuration, not history (see `PrefKeys.hydrationDailyGoalMl`).
///
/// Emits [HydrationLogged]/[HydrationUpdated]/[HydrationDeleted] onto the
/// shared [EventBus] for every mutation — never calls
/// `NotificationScheduler` directly. Hydration deliberately has no
/// [NotificationContributor] (nothing to schedule this phase).
///
/// All "now"/"today" values come from [ClockManager], not `DateTime.now()`
/// directly, so tests can drive the timeline with a fake clock.
class HydrationRepository {
  HydrationRepository(this._dao, this._eventBus, this._clock, this._prefs);

  final HydrationEntriesDao _dao;
  final EventBus _eventBus;
  final ClockManager _clock;
  final PreferencesService _prefs;

  Stream<List<HydrationEntry>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  /// Entries recorded on the current local day, newest first — the
  /// canonical source today's total is summed from, never a persisted
  /// running-total field (see `date_only.dart`'s doc comment on why
  /// calendar-day comparisons always go through [dateOnly]).
  Stream<List<HydrationEntry>> watchToday() {
    final today = dateOnly(_clock.now());
    final tomorrow = today.add(const Duration(days: 1));
    return _dao
        .watchBetween(today, tomorrow)
        .map((rows) => rows.map(_toEntity).toList());
  }

  Future<HydrationEntry?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  /// Rejects non-positive amounts — a zero/negative log is always a user
  /// input mistake, never a legitimate record (there's no "undo my last
  /// drink" concept; deletion covers that).
  Future<void> log({
    required String id,
    required int amountMl,
    DateTime? recordedAt,
  }) async {
    if (amountMl <= 0) {
      throw ArgumentError.value(amountMl, 'amountMl', 'must be positive');
    }
    final at = recordedAt ?? _clock.now();
    await _dao.insert(
      db.HydrationEntriesCompanion.insert(
        id: id,
        amountMl: amountMl,
        recordedAt: at,
        createdAt: at,
      ),
    );
    _eventBus.emit(HydrationLogged(entryId: id));
  }

  Future<void> update({required String id, required int amountMl}) async {
    if (amountMl <= 0) {
      throw ArgumentError.value(amountMl, 'amountMl', 'must be positive');
    }
    final existing = await _dao.getById(id);
    if (existing == null) return;
    await _dao.updateFields(
      id,
      db.HydrationEntriesCompanion(amountMl: Value(amountMl)),
    );
    _eventBus.emit(HydrationUpdated(entryId: id));
  }

  Future<void> delete(String id) async {
    await _dao.deleteById(id);
    _eventBus.emit(HydrationDeleted(entryId: id));
  }

  int getGoalMl() =>
      _prefs.getInt(PrefKeys.hydrationDailyGoalMl) ?? kDefaultHydrationGoalMl;

  Future<void> setGoalMl(int goalMl) async {
    if (goalMl <= 0) {
      throw ArgumentError.value(goalMl, 'goalMl', 'must be positive');
    }
    await _prefs.setInt(PrefKeys.hydrationDailyGoalMl, goalMl);
  }

  HydrationEntry _toEntity(db.HydrationEntry row) => HydrationEntry(
    id: row.id,
    amountMl: row.amountMl,
    recordedAt: row.recordedAt,
    createdAt: row.createdAt,
  );
}
