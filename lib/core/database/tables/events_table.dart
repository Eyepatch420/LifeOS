import 'package:drift/drift.dart';

/// One calendar event. `startAt` is always the effective sort/anchor
/// instant; `endAt` is nullable for a point-in-time event (see `Event`'s
/// doc comment for exact semantics). `isAllDay` events store `startAt`/
/// `endAt` as calendar-date midnights (local time) — [dateOnly]-normalized
/// by [EventsRepository] before persistence — so a timed-vs-all-day event
/// is never distinguished by an implicit "is the time midnight?" guess.
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime().nullable()();
  BoolColumn get isAllDay => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
