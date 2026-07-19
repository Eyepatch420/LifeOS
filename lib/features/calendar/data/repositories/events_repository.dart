import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/events_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/calendar/domain/entities/event.dart';
import 'package:lifeos/features/calendar/domain/events/event_events.dart';

/// The single owner of Calendar/Event persistence — every mutation and
/// query for events goes through here, wrapping [EventsDao] and mapping
/// Drift rows to the feature's own [Event] entity. No other feature imports
/// this class or [EventsDao] directly (see the Golden Rule in
/// `reminders_repository.dart`'s doc comment, which this mirrors).
///
/// Emits [EventCreated]/[EventUpdated]/[EventDeleted] onto the shared
/// [EventBus] for every mutation — never calls `NotificationScheduler`
/// directly.
class EventsRepository {
  EventsRepository(this._dao, this._eventBus);

  final EventsDao _dao;
  final EventBus _eventBus;

  Stream<List<Event>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  /// Live events overlapping the local calendar day [date] — a timed event
  /// is included if its [Event.startAt] falls on that day; an all-day event
  /// is included if [date] falls within its (inclusive) start/end calendar-
  /// date range. Multi-day timed events aren't a supported concept (the
  /// schema has no such notion — see `Events` table's doc comment), so a
  /// timed event is always attributed to its single start day only.
  Stream<List<Event>> watchForDate(DateTime date) {
    final day = dateOnly(date);
    return watchAll().map(
      (all) => all.where((event) => _occursOn(event, day)).toList(),
    );
  }

  Future<Event?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  Future<void> create({
    required String id,
    required String title,
    required DateTime startAt,
    required bool isAllDay,
    String? description,
    DateTime? endAt,
  }) async {
    final normalized = _normalize(
      startAt: startAt,
      endAt: endAt,
      isAllDay: isAllDay,
    );
    await _dao.upsert(
      db.EventsCompanion.insert(
        id: id,
        title: title,
        description: Value(description),
        startAt: normalized.startAt,
        endAt: Value(normalized.endAt),
        isAllDay: Value(isAllDay),
        createdAt: DateTime.now(),
      ),
    );
    _eventBus.emit(
      EventCreated(
        eventId: id,
        title: title,
        startAt: normalized.startAt,
        isAllDay: isAllDay,
      ),
    );
  }

  Future<void> update({
    required String id,
    required String title,
    required DateTime startAt,
    required bool isAllDay,
    String? description,
    DateTime? endAt,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) return;
    final normalized = _normalize(
      startAt: startAt,
      endAt: endAt,
      isAllDay: isAllDay,
    );
    await _dao.upsert(
      db.EventsCompanion(
        id: Value(id),
        title: Value(title),
        description: Value(description),
        startAt: Value(normalized.startAt),
        endAt: Value(normalized.endAt),
        isAllDay: Value(isAllDay),
        createdAt: Value(existing.createdAt),
        archivedAt: Value(existing.archivedAt),
      ),
    );
    _eventBus.emit(
      EventUpdated(
        eventId: id,
        title: title,
        startAt: normalized.startAt,
        isAllDay: isAllDay,
      ),
    );
  }

  Future<void> delete(String id) async {
    await _dao.archive(id);
    _eventBus.emit(EventDeleted(eventId: id));
  }

  Future<void> restore(String id) => _dao.restore(id);

  bool _occursOn(Event event, DateTime day) {
    if (event.isAllDay) {
      final start = dateOnly(event.startAt);
      final end = event.endAt == null ? start : dateOnly(event.endAt!);
      return !day.isBefore(start) && !day.isAfter(end);
    }
    return isSameDay(event.startAt, day);
  }

  /// All-day events store calendar-date-normalized (midnight, local)
  /// [Event.startAt]/[Event.endAt] — the single point this normalization
  /// happens, so nothing downstream has to guess whether a stored all-day
  /// timestamp is "really" midnight or an artifact of the create form.
  ({DateTime startAt, DateTime? endAt}) _normalize({
    required DateTime startAt,
    required DateTime? endAt,
    required bool isAllDay,
  }) {
    if (!isAllDay) return (startAt: startAt, endAt: endAt);
    return (
      startAt: dateOnly(startAt),
      endAt: endAt == null ? null : dateOnly(endAt),
    );
  }

  Event _toEntity(db.Event row) => Event(
    id: row.id,
    title: row.title,
    description: row.description,
    startAt: row.startAt,
    endAt: row.endAt,
    isAllDay: row.isAllDay,
    createdAt: row.createdAt,
    archivedAt: row.archivedAt,
  );
}
