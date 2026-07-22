import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/sleep_entries_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/sleep/domain/entities/sleep_entry.dart';
import 'package:lifeos/features/sleep/domain/entities/sleep_quality.dart';
import 'package:lifeos/features/sleep/domain/events/sleep_events.dart';

/// The single owner of Sleep persistence — every mutation/query goes
/// through here, wrapping [SleepEntriesDao] and mapping Drift rows to the
/// feature's own [SleepEntry] entity. No other feature imports this class
/// or [SleepEntriesDao] directly (Golden Rule, mirrors `MoodRepository`).
///
/// Emits [SleepLogged]/[SleepUpdated]/[SleepDeleted] onto the shared
/// [EventBus] for every mutation — never calls `NotificationScheduler`
/// directly. Sleep deliberately has no [NotificationContributor] (nothing
/// to schedule this phase).
///
/// All "now" values come from [ClockManager], not `DateTime.now()`
/// directly, so tests can drive the timeline with a fake clock.
class SleepRepository {
  SleepRepository(this._dao, this._eventBus, this._clock);

  final SleepEntriesDao _dao;
  final EventBus _eventBus;
  final ClockManager _clock;

  Stream<List<SleepEntry>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  Future<SleepEntry?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  /// Rejects a wake time at or before bedtime — every legitimate sleep
  /// record, including one crossing midnight, has [wakeTime] strictly after
  /// [bedtime] as absolute instants (the caller is responsible for rolling
  /// [wakeTime] onto the next calendar day when the user picks a wake time
  /// earlier in the clock than their bedtime).
  Future<void> log({
    required String id,
    required DateTime bedtime,
    required DateTime wakeTime,
    SleepQuality? quality,
    String? note,
  }) async {
    if (!wakeTime.isAfter(bedtime)) {
      throw ArgumentError.value(wakeTime, 'wakeTime', 'must be after bedtime');
    }
    await _dao.insert(
      db.SleepEntriesCompanion.insert(
        id: id,
        bedtime: bedtime,
        wakeTime: wakeTime,
        quality: Value(quality?.storageKey),
        note: Value(note),
        createdAt: _clock.now(),
      ),
    );
    _eventBus.emit(SleepLogged(entryId: id));
  }

  Future<void> update({
    required String id,
    required DateTime bedtime,
    required DateTime wakeTime,
    SleepQuality? quality,
    String? note,
  }) async {
    if (!wakeTime.isAfter(bedtime)) {
      throw ArgumentError.value(wakeTime, 'wakeTime', 'must be after bedtime');
    }
    final existing = await _dao.getById(id);
    if (existing == null) return;
    await _dao.updateFields(
      id,
      db.SleepEntriesCompanion(
        bedtime: Value(bedtime),
        wakeTime: Value(wakeTime),
        quality: Value(quality?.storageKey),
        note: Value(note),
      ),
    );
    _eventBus.emit(SleepUpdated(entryId: id));
  }

  Future<void> delete(String id) async {
    await _dao.deleteById(id);
    _eventBus.emit(SleepDeleted(entryId: id));
  }

  /// The most recently logged record (by [SleepEntry.wakeTime]), or `null`
  /// if nothing has ever been logged — the source Health Overview/Home
  /// would show as "latest sleep".
  Stream<SleepEntry?> watchLatest() {
    return watchAll().map((entries) => entries.isEmpty ? null : entries.first);
  }

  SleepEntry _toEntity(db.SleepEntry row) => SleepEntry(
    id: row.id,
    bedtime: row.bedtime,
    wakeTime: row.wakeTime,
    quality: row.quality == null
        ? null
        : SleepQuality.fromStorageKey(row.quality!),
    note: row.note,
    createdAt: row.createdAt,
  );
}
