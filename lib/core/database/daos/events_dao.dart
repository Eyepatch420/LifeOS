import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/events_table.dart';

part 'events_dao.g.dart';

@DriftAccessor(tables: [Events])
class EventsDao extends DatabaseAccessor<AppDatabase> with _$EventsDaoMixin {
  EventsDao(super.db);

  Stream<List<Event>> watchAll() {
    return (select(events)
          ..where((t) => t.archivedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.startAt)]))
        .watch();
  }

  Future<Event?> getById(String id) {
    return (select(
      events,
    )..where((t) => t.id.equals(id) & t.archivedAt.isNull())).getSingleOrNull();
  }

  Future<void> upsert(EventsCompanion entry) =>
      into(events).insertOnConflictUpdate(entry);

  Future<void> archive(String id) {
    return (update(events)..where((t) => t.id.equals(id))).write(
      EventsCompanion(archivedAt: Value(DateTime.now())),
    );
  }

  Future<void> restore(String id) {
    return (update(events)..where((t) => t.id.equals(id))).write(
      const EventsCompanion(archivedAt: Value(null)),
    );
  }
}
