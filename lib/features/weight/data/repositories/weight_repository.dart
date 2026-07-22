import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/weight_entries_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/weight/domain/entities/weight_entry.dart';
import 'package:lifeos/features/weight/domain/events/weight_events.dart';

/// The single owner of Weight persistence — every mutation/query goes
/// through here, wrapping [WeightEntriesDao] and mapping Drift rows to the
/// feature's own [WeightEntry] entity. No other feature imports this class
/// or [WeightEntriesDao] directly (Golden Rule, mirrors `MoodRepository`).
///
/// Emits [WeightLogged]/[WeightUpdated]/[WeightDeleted] onto the shared
/// [EventBus] for every mutation — never calls `NotificationScheduler`
/// directly. Weight deliberately has no [NotificationContributor] (nothing
/// to schedule this phase).
///
/// All "now" values come from [ClockManager], not `DateTime.now()`
/// directly, so tests can drive the timeline with a fake clock.
class WeightRepository {
  WeightRepository(this._dao, this._eventBus, this._clock);

  final WeightEntriesDao _dao;
  final EventBus _eventBus;
  final ClockManager _clock;

  /// Newest first (by [WeightEntry.recordedAt]).
  Stream<List<WeightEntry>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  Future<WeightEntry?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  /// Rejects non-positive weight — the purpose is catching obvious input
  /// mistakes (a stray minus sign, an empty field parsed as 0), not
  /// medically judging the value.
  Future<void> log({
    required String id,
    required double weightKg,
    String? note,
    DateTime? recordedAt,
  }) async {
    if (weightKg <= 0) {
      throw ArgumentError.value(weightKg, 'weightKg', 'must be positive');
    }
    final at = recordedAt ?? _clock.now();
    await _dao.insert(
      db.WeightEntriesCompanion.insert(
        id: id,
        weightKg: weightKg,
        note: Value(note),
        recordedAt: at,
        createdAt: at,
      ),
    );
    _eventBus.emit(WeightLogged(entryId: id));
  }

  Future<void> update({
    required String id,
    required double weightKg,
    String? note,
  }) async {
    if (weightKg <= 0) {
      throw ArgumentError.value(weightKg, 'weightKg', 'must be positive');
    }
    final existing = await _dao.getById(id);
    if (existing == null) return;
    await _dao.updateFields(
      id,
      db.WeightEntriesCompanion(weightKg: Value(weightKg), note: Value(note)),
    );
    _eventBus.emit(WeightUpdated(entryId: id));
  }

  Future<void> delete(String id) async {
    await _dao.deleteById(id);
    _eventBus.emit(WeightDeleted(entryId: id));
  }

  Stream<WeightEntry?> watchLatest() {
    return watchAll().map((entries) => entries.isEmpty ? null : entries.first);
  }

  WeightEntry _toEntity(db.WeightEntry row) => WeightEntry(
    id: row.id,
    weightKg: row.weightKg,
    note: row.note,
    recordedAt: row.recordedAt,
    createdAt: row.createdAt,
  );
}
