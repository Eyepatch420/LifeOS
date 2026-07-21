import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/mood_entries_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/mood/domain/entities/mood_entry.dart';
import 'package:lifeos/features/mood/domain/entities/mood_level.dart';
import 'package:lifeos/features/mood/domain/events/mood_events.dart';

/// The single owner of Mood persistence — every mutation and query for mood
/// entries goes through here, wrapping [MoodEntriesDao] and mapping Drift
/// rows to the feature's own [MoodEntry] entity. No other feature imports
/// this class or [MoodEntriesDao] directly (Golden Rule, mirrors
/// `HabitsRepository`).
///
/// Emits [MoodLogged]/[MoodUpdated]/[MoodDeleted] onto the shared [EventBus]
/// for every mutation — never calls `NotificationScheduler` directly. Mood
/// deliberately has no [NotificationContributor] (nothing to schedule).
///
/// All "now"/"today" values come from [ClockManager], not `DateTime.now()`
/// directly, so tests can drive the timeline with a fake clock.
class MoodRepository {
  MoodRepository(this._dao, this._eventBus, this._clock);

  final MoodEntriesDao _dao;
  final EventBus _eventBus;
  final ClockManager _clock;

  Stream<List<MoodEntry>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  Future<MoodEntry?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  Future<void> log({
    required String id,
    required MoodLevel level,
    String? note,
    DateTime? recordedAt,
  }) async {
    final at = recordedAt ?? _clock.now();
    await _dao.insert(
      db.MoodEntriesCompanion.insert(
        id: id,
        moodLevel: level.storageKey,
        note: Value(note),
        recordedAt: at,
        createdAt: at,
      ),
    );
    _eventBus.emit(MoodLogged(entryId: id));
  }

  Future<void> update({
    required String id,
    required MoodLevel level,
    String? note,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) return;
    await _dao.updateFields(
      id,
      db.MoodEntriesCompanion(
        moodLevel: Value(level.storageKey),
        note: Value(note),
      ),
    );
    _eventBus.emit(MoodUpdated(entryId: id));
  }

  Future<void> delete(String id) async {
    await _dao.deleteById(id);
    _eventBus.emit(MoodDeleted(entryId: id));
  }

  /// Live entries recorded on the current local day, newest first — the
  /// canonical source "today's mood" (latest entry) derives from, never a
  /// persisted "current mood" field (see `date_only.dart`'s doc comment on
  /// why calendar-day comparisons always go through [dateOnly]).
  Stream<List<MoodEntry>> watchToday() {
    final today = dateOnly(_clock.now());
    return watchAll().map(
      (entries) =>
          entries.where((e) => isSameDay(e.recordedAt, today)).toList(),
    );
  }

  MoodEntry _toEntity(db.MoodEntry row) => MoodEntry(
    id: row.id,
    level: MoodLevel.fromStorageKey(row.moodLevel),
    note: row.note,
    recordedAt: row.recordedAt,
    createdAt: row.createdAt,
  );
}
