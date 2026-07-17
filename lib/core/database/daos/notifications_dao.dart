import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/notifications_table.dart';

part 'notifications_dao.g.dart';

@DriftAccessor(tables: [Notifications])
class NotificationsDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationsDaoMixin {
  NotificationsDao(super.db);

  Stream<List<NotificationRecord>> watchAll() {
    return (select(
      notifications,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Future<void> insert(NotificationsCompanion entry) =>
      into(notifications).insertOnConflictUpdate(entry);

  Future<void> markRead(String id) {
    return (update(notifications)..where((t) => t.id.equals(id))).write(
      NotificationsCompanion(readAt: Value(DateTime.now())),
    );
  }
}
