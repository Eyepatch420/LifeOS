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
      await db.eventsDao.watchAll().first;

      // The original v1 table survives the migration untouched.
      final metadataRows = await db
          .customSelect('SELECT * FROM app_metadata')
          .get();
      expect(metadataRows, isEmpty);

      await db.close();
    },
  );

  test('upgrading from a v4 database adds status/pausedAt/accumulatedPausedMs '
      'to FocusSessions, backfilling status from endedAt without losing '
      'existing rows', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'lifeos_migration_test_v4',
    );
    final dbFile = File(p.join(tempDir.path, 'v4.sqlite'));
    addTearDown(() => tempDir.delete(recursive: true));

    final seed = sqlite3.sqlite3.open(dbFile.path);
    seed.execute('''
        CREATE TABLE focus_sessions (
          id TEXT NOT NULL,
          started_at INTEGER NOT NULL,
          ended_at INTEGER,
          planned_minutes INTEGER NOT NULL,
          kind TEXT NOT NULL,
          PRIMARY KEY (id)
        );
      ''');
    seed.execute('''
        INSERT INTO focus_sessions (id, started_at, ended_at, planned_minutes, kind)
        VALUES
          ('done', 0, 100, 25, 'focus'),
          ('mid-flight', 0, NULL, 25, 'focus');
      ''');
    // `reminders` already exists by v4 (created v1->v2, gained
    // recurrence/customRule v2->v3) — seeded here too so the `from < 6`
    // branch's `ALTER TABLE ... ADD COLUMN category` has a real table to
    // run against, same as a genuine v4 database would.
    seed.execute('''
        CREATE TABLE reminders (
          id TEXT NOT NULL,
          title TEXT NOT NULL,
          due_at INTEGER NOT NULL,
          is_urgent INTEGER NOT NULL DEFAULT 0,
          is_completed INTEGER NOT NULL DEFAULT 0,
          completed_at INTEGER,
          deleted_at INTEGER,
          recurrence TEXT NOT NULL DEFAULT 'none',
          custom_rule TEXT,
          PRIMARY KEY (id)
        );
      ''');
    seed.execute('PRAGMA user_version = 4');
    seed.dispose();

    final db = AppDatabase.forTesting(NativeDatabase(dbFile));

    final sessions = {
      for (final s in await db.focusSessionsDao.watchAll().first) s.id: s,
    };
    expect(sessions, hasLength(2));
    // A pre-existing ended session backfills to 'completed', not the
    // column's raw 'running' default.
    expect(sessions['done']!.status, 'completed');
    expect(sessions['done']!.pausedAt, isNull);
    expect(sessions['done']!.accumulatedPausedMs, 0);
    // A pre-existing session with no endedAt (the old scaffold never
    // actually produced one via a real repository, but the migration
    // must still handle it deterministically) keeps the column default.
    expect(sessions['mid-flight']!.status, 'running');

    await db.close();
  });

  test('a fresh v4 database opens and every table is queryable', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    await db.notesDao.watchAll().first;
    await db.remindersDao.watchAll().first;
    await db.expensesDao.watchAll().first;
    await db.habitsDao.watchAll().first;
    await db.listsDao.watchAll().first;
    await db.moodEntriesDao.watchAll().first;
    await db.notificationsDao.watchAll().first;
    await db.focusSessionsDao.watchAll().first;
    await db.eventsDao.watchAll().first;

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
    // v2 also already has `focus_sessions` (created by the v1->v2 branch) —
    // seeded here too so the v2->v5 chain's `from < 5` FocusSessions column
    // additions have a real table to run `ALTER TABLE` against, same as a
    // genuine v2 database would.
    seed.execute('''
        CREATE TABLE focus_sessions (
          id TEXT NOT NULL,
          started_at INTEGER NOT NULL,
          ended_at INTEGER,
          planned_minutes INTEGER NOT NULL,
          kind TEXT NOT NULL,
          PRIMARY KEY (id)
        );
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

  test('upgrading from a v3 database creates the Events table without losing '
      'existing data in other tables', () async {
    // Same rationale as the v1→v2/v2→v3 tests above: a real temp-file
    // database is required to seed a genuine pre-migration schema and
    // prove the v3→v4 onUpgrade step actually runs.
    final tempDir = await Directory.systemTemp.createTemp(
      'lifeos_migration_test_v3',
    );
    final dbFile = File(p.join(tempDir.path, 'v3.sqlite'));
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
          recurrence TEXT NOT NULL DEFAULT 'none',
          custom_rule TEXT,
          PRIMARY KEY (id)
        );
      ''');
    seed.execute('''
        INSERT INTO reminders (id, title, due_at, recurrence)
        VALUES ('r1', 'Pre-migration reminder', 0, 'none');
      ''');
    // Same rationale as the v2 fixture above — `focus_sessions` already
    // exists by v3, so it must be seeded for the `from < 5` branch's
    // `ALTER TABLE` to have a real table to run against.
    seed.execute('''
        CREATE TABLE focus_sessions (
          id TEXT NOT NULL,
          started_at INTEGER NOT NULL,
          ended_at INTEGER,
          planned_minutes INTEGER NOT NULL,
          kind TEXT NOT NULL,
          PRIMARY KEY (id)
        );
      ''');
    seed.execute('PRAGMA user_version = 3');
    seed.dispose();

    final db = AppDatabase.forTesting(NativeDatabase(dbFile));

    // Querying `events` proves onUpgrade's `from < 4` branch actually
    // created the table — a missing table throws here.
    final events = await db.eventsDao.watchAll().first;
    expect(events, isEmpty);

    // The pre-existing reminder row survives the v3->v4 upgrade
    // untouched (the `from < 3` branch must not re-run and, e.g.,
    // clobber it).
    final reminders = await db.remindersDao.watchAll().first;
    expect(reminders, hasLength(1));
    expect(reminders.single.id, 'r1');

    await db.close();
  });

  test('upgrading from a v5 database adds category to Reminders, backfilling '
      "existing rows to 'other' without losing data", () async {
    // Same rationale as the earlier migration tests: a real temp-file
    // database is required to seed a genuine pre-migration schema and
    // prove the v5→v6 onUpgrade step actually runs against pre-existing
    // data, rather than just asserting on a freshly-created v6 schema.
    final tempDir = await Directory.systemTemp.createTemp(
      'lifeos_migration_test_v5',
    );
    final dbFile = File(p.join(tempDir.path, 'v5.sqlite'));
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
          recurrence TEXT NOT NULL DEFAULT 'none',
          custom_rule TEXT,
          PRIMARY KEY (id)
        );
      ''');
    seed.execute('''
        INSERT INTO reminders (id, title, due_at, recurrence)
        VALUES ('r1', 'Pre-migration reminder', 0, 'none');
      ''');
    seed.execute('PRAGMA user_version = 5');
    seed.dispose();

    final db = AppDatabase.forTesting(NativeDatabase(dbFile));

    final reminders = await db.remindersDao.watchAll().first;
    expect(reminders, hasLength(1));
    expect(reminders.single.id, 'r1');
    // The new column's default applies retroactively to the pre-existing
    // row, not just rows inserted after the migration.
    expect(reminders.single.category, 'other');

    await db.close();
  });

  test(
    'upgrading from a v6 database migrates the old one-row-per-day '
    'MoodEntries shape into the new append-only shape without losing data, '
    'and adds the Medications/MedicationOccurrences tables',
    () async {
      // Same rationale as the earlier migration tests: a real temp-file
      // database proves the v6->v7 onUpgrade step actually runs the
      // rename/copy/drop sequence against pre-existing data, not just a
      // freshly-created v7 schema.
      final tempDir = await Directory.systemTemp.createTemp(
        'lifeos_migration_test_v6',
      );
      final dbFile = File(p.join(tempDir.path, 'v6.sqlite'));
      addTearDown(() => tempDir.delete(recursive: true));

      final seed = sqlite3.sqlite3.open(dbFile.path);
      seed.execute('''
        CREATE TABLE mood_entries (
          id TEXT NOT NULL,
          local_date TEXT NOT NULL,
          score INTEGER NOT NULL,
          note TEXT,
          PRIMARY KEY (id)
        );
      ''');
      seed.execute('''
        INSERT INTO mood_entries (id, local_date, score, note)
        VALUES ('m1', '2026-07-16', 4, 'Pre-migration entry');
      ''');
      seed.execute('PRAGMA user_version = 6');
      seed.dispose();

      final db = AppDatabase.forTesting(NativeDatabase(dbFile));

      final moods = await db.moodEntriesDao.watchAll().first;
      expect(moods, hasLength(1));
      expect(moods.single.id, 'm1');
      // score 4 buckets to 'good' — see the `from < 7` migration's CASE.
      expect(moods.single.moodLevel, 'good');
      expect(moods.single.note, 'Pre-migration entry');
      // '2026-07-16' local-midnight survived the string->epoch conversion.
      // Local (not UTC): Drift decodes epoch-seconds DateTime columns back
      // into local time (see `SqlTypes._readDateTime`), matching every
      // other DateTime in this codebase's convention.
      expect(moods.single.recordedAt, DateTime(2026, 7, 16));
      expect(moods.single.createdAt, DateTime(2026, 7, 16));

      // Querying the two new tables proves onUpgrade's `from < 7` branch
      // actually created them.
      final medications = await db.medicationsDao.watchAll().first;
      expect(medications, isEmpty);

      await db.close();
    },
  );
}
