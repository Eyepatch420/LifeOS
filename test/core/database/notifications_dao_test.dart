import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('insert then watchAll returns it unread', () async {
    await db.notificationsDao.insert(
      NotificationsCompanion.insert(
        id: 'n1',
        sourceModule: 'reminders',
        sourceId: 'r1',
        title: 'Overdue',
        body: 'A reminder is overdue',
        createdAt: DateTime.now(),
      ),
    );

    final all = await db.notificationsDao.watchAll().first;
    expect(all, hasLength(1));
    expect(all.single.readAt, isNull);
  });

  test('markRead sets readAt', () async {
    await db.notificationsDao.insert(
      NotificationsCompanion.insert(
        id: 'n1',
        sourceModule: 'reminders',
        sourceId: 'r1',
        title: 'Overdue',
        body: 'A reminder is overdue',
        createdAt: DateTime.now(),
      ),
    );

    await db.notificationsDao.markRead('n1');

    final all = await db.notificationsDao.watchAll().first;
    expect(all.single.readAt, isNotNull);
  });

  test('watchAll orders by createdAt descending', () async {
    final now = DateTime.now();
    await db.notificationsDao.insert(
      NotificationsCompanion.insert(
        id: 'old',
        sourceModule: 'reminders',
        sourceId: 'r1',
        title: 'Old',
        body: 'Body',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
    );
    await db.notificationsDao.insert(
      NotificationsCompanion.insert(
        id: 'new',
        sourceModule: 'reminders',
        sourceId: 'r2',
        title: 'New',
        body: 'Body',
        createdAt: now,
      ),
    );

    final all = await db.notificationsDao.watchAll().first;
    expect(all.map((n) => n.id), ['new', 'old']);
  });
}
