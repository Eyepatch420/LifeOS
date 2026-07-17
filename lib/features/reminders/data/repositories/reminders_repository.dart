import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/reminders_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
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

  Future<void> setCompleted(String id, bool isCompleted) async {
    await _dao.setCompleted(id, isCompleted);
    if (isCompleted) {
      _eventBus.emit(ReminderCompleted(reminderId: id));
      return;
    }
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
