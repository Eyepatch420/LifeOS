import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite3;

void main() {
  test(
    'upgrading from a v1 database (AppMetadata only) creates all v2 tables',
    () async {
      // A real (temp-file) database is required here since the test needs
      // to seed Module 1's actual shipped v1 schema (just `AppMetadata`,
      // `PRAGMA user_version = 1`) via a raw sqlite3 connection, then
      // reopen the same file through AppDatabase (schema v2) so its real
      // onUpgrade path runs against pre-existing data. A
      // NativeDatabase.memory() instance can't be reopened by a second
      // connection, so it can't prove the upgrade path actually executes.
      final tempDir = await Directory.systemTemp.createTemp(
        'lifeos_migration_test',
      );
      final dbFile = File(p.join(tempDir.path, 'v1.sqlite'));
      addTearDown(() => tempDir.delete(recursive: true));

      final seed = sqlite3.sqlite3.open(dbFile.path);
      seed.execute('''
        CREATE TABLE app_metadata (
          "key" TEXT NOT NULL,
          value TEXT NOT NULL,
          PRIMARY KEY ("key")
        );
      ''');
      seed.execute('PRAGMA user_version = 1');
      seed.dispose();

      final db = AppDatabase.forTesting(NativeDatabase(dbFile));

      // Querying every new table proves onUpgrade actually created it — a
      // missing table throws here instead of silently no-op'ing.
      await db.notesDao.watchAll().first;
      await db.remindersDao.watchAll().first;
      await db.expensesDao.watchAll().first;
      await db.habitsDao.watchAll().first;
      await db.listsDao.watchAll().first;
      await db.moodEntriesDao.watchAll().first;
      await db.notificationsDao.watchAll().first;
      await db.focusSessionsDao.watchAll().first;

      // The original v1 table survives the migration untouched.
      final metadataRows = await db
          .customSelect('SELECT * FROM app_metadata')
          .get();
      expect(metadataRows, isEmpty);

      await db.close();
    },
  );

  test('a fresh v3 database opens and every table is queryable', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    await db.notesDao.watchAll().first;
    await db.remindersDao.watchAll().first;
    await db.expensesDao.watchAll().first;
    await db.habitsDao.watchAll().first;
    await db.listsDao.watchAll().first;
    await db.moodEntriesDao.watchAll().first;
    await db.notificationsDao.watchAll().first;
    await db.focusSessionsDao.watchAll().first;

    await db.close();
  });

  test('upgrading from a v2 database adds recurrence/customRule to Reminders '
      'without losing existing rows', () async {
    // Same rationale as the v1→v2 test above: a real temp-file database
    // is required to seed a genuine pre-migration schema and prove the
    // v2→v3 onUpgrade step actually runs against pre-existing data,
    // rather than just asserting on a freshly-created v3 schema.
    final tempDir = await Directory.systemTemp.createTemp(
      'lifeos_migration_test_v2',
    );
    final dbFile = File(p.join(tempDir.path, 'v2.sqlite'));
    addTearDown(() => tempDir.delete(recursive: true));

    final seed = sqlite3.sqlite3.open(dbFile.path);
    seed.execute('''
        CREATE TABLE reminders (
          id TEXT NOT NULL,
          title TEXT NOT NULL,
          due_at INTEGER NOT NULL,
          is_urgent INTEGER NOT NULL DEFAULT 0,
          is_completed INTEGER NOT NULL DEFAULT 0,
          completed_at INTEGER,
          deleted_at INTEGER,
          PRIMARY KEY (id)
        );
      ''');
    seed.execute('''
        INSERT INTO reminders (id, title, due_at, is_urgent, is_completed)
        VALUES ('r1', 'Pre-migration reminder', 0, 0, 0);
      ''');
    seed.execute('PRAGMA user_version = 2');
    seed.dispose();

    final db = AppDatabase.forTesting(NativeDatabase(dbFile));

    final reminders = await db.remindersDao.watchAll().first;
    expect(reminders, hasLength(1));
    expect(reminders.single.id, 'r1');
    // The new column's default applies retroactively to the pre-existing
    // row, not just rows inserted after the migration.
    expect(reminders.single.recurrence, 'none');
    expect(reminders.single.customRule, isNull);

    await db.close();
  });
}
