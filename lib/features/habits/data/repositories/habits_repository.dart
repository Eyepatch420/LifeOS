import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/habits_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/extensions/datetime_extensions.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/habits/domain/entities/habit.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/domain/events/habit_events.dart';

/// The single owner of Habits persistence — every mutation and query for
/// habits goes through here, wrapping [HabitsDao] and mapping Drift rows to
/// the feature's own [Habit] entity. No other feature imports this class or
/// [HabitsDao] directly (see the Golden Rule in
/// `reminders_repository.dart`'s doc comment, which this mirrors).
///
/// Emits [HabitCreated]/[HabitUpdated]/[HabitCompleted]/[HabitArchived] onto
/// the shared [EventBus] for every mutation — never calls
/// `NotificationScheduler` directly.
class HabitsRepository {
  HabitsRepository(this._dao, this._eventBus);

  final HabitsDao _dao;
  final EventBus _eventBus;

  Stream<List<Habit>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  Future<Habit?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  /// Live completion history for [habitId] as a set of local calendar
  /// dates (already [dateOnly]-normalized) — the canonical source streak
  /// calculation and day-classification derive from, never a mutable
  /// counter column.
  Stream<Set<DateTime>> watchCompletionDates(String habitId) {
    return _dao
        .watchCompletions(habitId)
        .map(
          (rows) =>
              rows.map((row) => _parseLocalDateKey(row.localDate)).toSet(),
        );
  }

  Future<void> create({
    required String id,
    required String title,
    required HabitSchedule schedule,
    required String icon,
  }) async {
    await _dao.upsert(
      db.HabitsCompanion.insert(
        id: id,
        title: title,
        targetFrequency: schedule.storageFrequency,
        scheduleDays: Value(schedule.storageScheduleDays),
        icon: icon,
        createdAt: DateTime.now(),
      ),
    );
    _eventBus.emit(HabitCreated(habitId: id, title: title));
  }

  Future<void> update({
    required String id,
    required String title,
    required HabitSchedule schedule,
    required String icon,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) return;
    await _dao.upsert(
      db.HabitsCompanion(
        id: Value(id),
        title: Value(title),
        targetFrequency: Value(schedule.storageFrequency),
        scheduleDays: Value(schedule.storageScheduleDays),
        icon: Value(icon),
        createdAt: Value(existing.createdAt),
        archivedAt: Value(existing.archivedAt),
      ),
    );
    _eventBus.emit(HabitUpdated(habitId: id, title: title));
  }

  /// The single semantic "set today's (or any date's) completion state"
  /// operation. Idempotent: calling this twice with the same [completed]
  /// value for the same [date] is a no-op the second time (see
  /// `HabitsDao.setCompletedForDate`'s doc comment) — tapping complete
  /// twice never creates duplicate completion records.
  Future<void> setCompletedForDate(
    String habitId,
    DateTime date, {
    required bool completed,
  }) async {
    final localDate = dateOnly(date).localDateKey;
    await _dao.setCompletedForDate(
      habitId,
      localDate,
      completed: completed,
      newId: () => '$habitId-$localDate',
    );
    if (completed) {
      _eventBus.emit(HabitCompleted(habitId: habitId, localDate: localDate));
    } else {
      final habit = await getById(habitId);
      if (habit != null) {
        _eventBus.emit(HabitUpdated(habitId: habitId, title: habit.title));
      }
    }
  }

  Future<void> archive(String id) async {
    await _dao.archive(id);
    _eventBus.emit(HabitArchived(habitId: id));
  }

  Future<void> restore(String id) => _dao.restore(id);

  Habit _toEntity(db.Habit row) => Habit(
    id: row.id,
    title: row.title,
    schedule: HabitSchedule.fromStorage(
      targetFrequency: row.targetFrequency,
      scheduleDays: row.scheduleDays,
    ),
    icon: row.icon,
    createdAt: row.createdAt,
    archivedAt: row.archivedAt,
  );

  DateTime _parseLocalDateKey(String key) {
    final parts = key.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
