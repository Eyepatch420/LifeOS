import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/habits_table.dart';

part 'habits_dao.g.dart';

@DriftAccessor(tables: [Habits, HabitCompletions])
class HabitsDao extends DatabaseAccessor<AppDatabase> with _$HabitsDaoMixin {
  HabitsDao(super.db);

  Stream<List<Habit>> watchAll() {
    return (select(habits)
          ..where((t) => t.archivedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Future<Habit?> getById(String id) {
    return (select(habits)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsert(HabitsCompanion entry) =>
      into(habits).insertOnConflictUpdate(entry);

  Future<void> archive(String id) {
    return (update(habits)..where((t) => t.id.equals(id))).write(
      HabitsCompanion(archivedAt: Value(DateTime.now())),
    );
  }

  Future<void> restore(String id) {
    return (update(habits)..where((t) => t.id.equals(id))).write(
      const HabitsCompanion(archivedAt: Value(null)),
    );
  }

  Stream<List<HabitCompletion>> watchCompletions(String habitId) {
    return (select(
      habitCompletions,
    )..where((t) => t.habitId.equals(habitId))).watch();
  }

  Future<HabitCompletion?> _completionForDate(
    String habitId,
    String localDate,
  ) {
    return (select(habitCompletions)..where(
          (t) => t.habitId.equals(habitId) & t.localDate.equals(localDate),
        ))
        .getSingleOrNull();
  }

  /// Toggles the completion row for [habitId] on [localDate] (`yyyy-MM-dd`):
  /// inserts if absent, deletes if present. Idempotent-safe under rapid
  /// double-taps because it always re-reads current state first.
  Future<void> toggleCompletion(
    String habitId,
    String localDate,
    String Function() newId,
  ) async {
    final existing = await _completionForDate(habitId, localDate);
    if (existing != null) {
      await (delete(
        habitCompletions,
      )..where((t) => t.id.equals(existing.id))).go();
    } else {
      await into(habitCompletions).insert(
        HabitCompletionsCompanion.insert(
          id: newId(),
          habitId: habitId,
          localDate: localDate,
        ),
      );
    }
  }

  /// Sets (not toggles) the completion state for [habitId] on [localDate].
  /// Unlike [toggleCompletion], calling this twice with the same
  /// [completed] value is a no-op the second time — the canonical operation
  /// for "mark today done"/"undo today" UI actions, where the caller knows
  /// the target state rather than wanting to flip whatever it currently is.
  Future<void> setCompletedForDate(
    String habitId,
    String localDate, {
    required bool completed,
    required String Function() newId,
  }) async {
    final existing = await _completionForDate(habitId, localDate);
    if (completed) {
      if (existing != null) return;
      await into(habitCompletions).insert(
        HabitCompletionsCompanion.insert(
          id: newId(),
          habitId: habitId,
          localDate: localDate,
        ),
      );
    } else {
      if (existing == null) return;
      await (delete(
        habitCompletions,
      )..where((t) => t.id.equals(existing.id))).go();
    }
  }
}
