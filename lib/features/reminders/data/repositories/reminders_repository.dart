import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/reminders_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_calculator.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';
import 'package:lifeos/features/reminders/domain/events/reminder_events.dart';

/// The single owner of Reminders persistence — every mutation and query
/// for reminders goes through here, wrapping [RemindersDao] and mapping
/// Drift rows to the feature's own [Reminder] entity. No other feature
/// imports this class or [RemindersDao] directly (see the Golden Rule).
///
/// Emits [ReminderCreated]/[ReminderUpdated]/[ReminderCompleted]/
/// [ReminderDeleted] onto the shared [EventBus] for every mutation —
/// never calls `NotificationScheduler` or any platform channel directly.
/// [NotificationEngine] (via `RemindersNotificationContributor`) is the
/// only consumer that turns these into real scheduling calls.
class RemindersRepository {
  RemindersRepository(this._dao, this._eventBus);

  final RemindersDao _dao;
  final EventBus _eventBus;

  Stream<List<Reminder>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  Future<Reminder?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  Future<void> create({
    required String id,
    required String title,
    required DateTime dueAt,
    required bool isUrgent,
    RecurrenceRule recurrence = RecurrenceRule.none,
    String? customRule,
  }) async {
    await _dao.upsert(
      db.RemindersCompanion.insert(
        id: id,
        title: title,
        dueAt: dueAt,
        isUrgent: Value(isUrgent),
        recurrence: Value(recurrence.storageKey),
        customRule: Value(customRule),
      ),
    );
    _eventBus.emit(ReminderCreated(reminderId: id, title: title, dueAt: dueAt));
  }

  Future<void> update({
    required String id,
    required String title,
    required DateTime dueAt,
    required bool isUrgent,
    required RecurrenceRule recurrence,
    String? customRule,
  }) async {
    await _dao.updateFields(
      id,
      db.RemindersCompanion(
        title: Value(title),
        dueAt: Value(dueAt),
        isUrgent: Value(isUrgent),
        recurrence: Value(recurrence.storageKey),
        customRule: Value(customRule),
      ),
    );
    _eventBus.emit(ReminderUpdated(reminderId: id, title: title, dueAt: dueAt));
  }

  /// The single semantic "complete this reminder" operation — every caller
  /// (dashboard, list, detail) goes through this, never a divergent
  /// recurrence-aware/non-aware split at the UI layer (see
  /// docs/architecture_principles.md's standing rule against presentation
  /// code branching on domain fields like `recurrence`).
  ///
  /// For a non-recurring reminder ([RecurrenceRule.none]), behaves exactly
  /// as before: `isCompleted = true`, `completedAt = now`, emits
  /// [ReminderCompleted] (cancels the pending notification).
  ///
  /// For a recurring reminder, "completing" it means completing *this*
  /// occurrence and advancing to the next one — the single-row recurring
  /// model chosen for Phase 4 (see reminders_repository.dart's module doc
  /// and docs/architecture_principles.md's Reminders recurrence section):
  /// `dueAt` advances to [nextOccurrence], the row stays/returns to
  /// `isCompleted = false` (it's pending again, for its next occurrence),
  /// `completedAt` stays null, and a [ReminderUpdated] is emitted instead
  /// of [ReminderCompleted] — the correct notification-lifecycle
  /// consequence is "reschedule for the new dueAt", not "cancel", since the
  /// series is still active. If [nextOccurrence] returns null (only
  /// possible for [RecurrenceRule.custom], whose semantics aren't defined —
  /// see [nextOccurrence]'s doc comment), falls back to the non-recurring
  /// completion behavior rather than silently doing nothing.
  ///
  /// [setCompleted]... false] (un-completing) is unchanged: only meaningful
  /// for a non-recurring reminder that was previously completed (a
  /// recurring reminder is never left `isCompleted = true` by this method),
  /// and re-emits [ReminderUpdated] so its notification reschedules.
  Future<void> setCompleted(String id, bool isCompleted) async {
    if (isCompleted) {
      final row = await _dao.getById(id);
      if (row == null) return;

      final recurrence = RecurrenceRule.fromStorageKey(row.recurrence);
      final next = nextOccurrence(row.dueAt, recurrence);

      if (next == null) {
        await _dao.setCompleted(id, true);
        _eventBus.emit(ReminderCompleted(reminderId: id));
        return;
      }

      await _dao.updateFields(id, db.RemindersCompanion(dueAt: Value(next)));
      _eventBus.emit(
        ReminderUpdated(reminderId: id, title: row.title, dueAt: next),
      );
      return;
    }

    await _dao.setCompleted(id, false);
    // Un-completing a reminder is effectively "this is active again" —
    // treated as an update so a future occurrence gets rescheduled rather
    // than staying silently cancelled. Needs a re-read since the caller
    // only supplied `id`/`isCompleted`, not the reminder's content.
    final row = await _dao.getById(id);
    if (row == null) return;
    _eventBus.emit(
      ReminderUpdated(reminderId: id, title: row.title, dueAt: row.dueAt),
    );
  }

  Future<void> delete(String id) async {
    await _dao.softDelete(id);
    _eventBus.emit(ReminderDeleted(reminderId: id));
  }

  Future<void> restore(String id) => _dao.restore(id);

  Reminder _toEntity(db.Reminder row) => Reminder(
    id: row.id,
    title: row.title,
    dueAt: row.dueAt,
    isUrgent: row.isUrgent,
    isCompleted: row.isCompleted,
    completedAt: row.completedAt,
    recurrence: RecurrenceRule.fromStorageKey(row.recurrence),
    customRule: row.customRule,
  );
}
