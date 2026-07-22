import 'package:drift/drift.dart';
import 'package:lifeos/core/database/daos/daily_activity_dao.dart';
import 'package:lifeos/core/database/daos/events_dao.dart';
import 'package:lifeos/core/database/daos/expenses_dao.dart';
import 'package:lifeos/core/database/daos/focus_sessions_dao.dart';
import 'package:lifeos/core/database/daos/habits_dao.dart';
import 'package:lifeos/core/database/daos/hydration_entries_dao.dart';
import 'package:lifeos/core/database/daos/lists_dao.dart';
import 'package:lifeos/core/database/daos/medications_dao.dart';
import 'package:lifeos/core/database/daos/mood_entries_dao.dart';
import 'package:lifeos/core/database/daos/notes_dao.dart';
import 'package:lifeos/core/database/daos/notifications_dao.dart';
import 'package:lifeos/core/database/daos/reminders_dao.dart';
import 'package:lifeos/core/database/daos/sleep_entries_dao.dart';
import 'package:lifeos/core/database/daos/weight_entries_dao.dart';
import 'package:lifeos/core/database/database_connection.dart';
import 'package:lifeos/core/database/tables/daily_activity_table.dart';
import 'package:lifeos/core/database/tables/events_table.dart';
import 'package:lifeos/core/database/tables/expenses_table.dart';
import 'package:lifeos/core/database/tables/focus_sessions_table.dart';
import 'package:lifeos/core/database/tables/habits_table.dart';
import 'package:lifeos/core/database/tables/hydration_entries_table.dart';
import 'package:lifeos/core/database/tables/lists_table.dart';
import 'package:lifeos/core/database/tables/medication_occurrences_table.dart';
import 'package:lifeos/core/database/tables/medications_table.dart';
import 'package:lifeos/core/database/tables/mood_entries_table.dart';
import 'package:lifeos/core/database/tables/notes_table.dart';
import 'package:lifeos/core/database/tables/notifications_table.dart';
import 'package:lifeos/core/database/tables/reminders_table.dart';
import 'package:lifeos/core/database/tables/sleep_entries_table.dart';
import 'package:lifeos/core/database/tables/weight_entries_table.dart';

part 'app_database.g.dart';

/// A trivial key-value table used only to prove out the Drift/build_runner
/// pipeline in Module 1. Superseded by the real tables below as of schema
/// v2, but kept (rather than dropped) since dropping a table on upgrade is
/// an unforced destructive migration with no benefit — nothing reads it.
class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    AppMetadata,
    Notes,
    Reminders,
    Expenses,
    Habits,
    HabitCompletions,
    Lists,
    ListItems,
    MoodEntries,
    Notifications,
    FocusSessions,
    Events,
    Medications,
    MedicationOccurrences,
    HydrationEntries,
    SleepEntries,
    WeightEntries,
    DailyActivity,
  ],
  daos: [
    NotesDao,
    RemindersDao,
    ExpensesDao,
    HabitsDao,
    ListsDao,
    MoodEntriesDao,
    NotificationsDao,
    FocusSessionsDao,
    EventsDao,
    MedicationsDao,
    HydrationEntriesDao,
    SleepEntriesDao,
    WeightEntriesDao,
    DailyActivityDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  /// Accepts an injected [QueryExecutor] or [DatabaseConnection] (typically
  /// `NativeDatabase.memory()`) so tests exercise the real Drift
  /// schema/migrations without touching disk or the platform channel
  /// `openConnection()` requires. Widget tests specifically should wrap
  /// their executor in `DatabaseConnection.fromExecutor(executor,
  /// closeStreamsSynchronously: true)` — otherwise a `StreamBuilder`
  /// disposed mid-test leaves a pending zero-duration `Timer` that trips
  /// `flutter_test`'s "must not have pending timers" invariant check.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(notes);
        // `reminders` is created here using its *current* column set
        // (via the live `Reminders` table class), so a v1→v4 upgrade
        // already gets `recurrence`/`customRule` for free — the `from < 3`
        // branch below only needs to run for a v2→v3 upgrade, never
        // stacked on top of this branch.
        await m.createTable(reminders);
        await m.createTable(expenses);
        await m.createTable(habits);
        await m.createTable(habitCompletions);
        await m.createTable(lists);
        await m.createTable(listItems);
        await m.createTable(moodEntries);
        await m.createTable(notifications);
        await m.createTable(focusSessions);
        await m.createTable(events);
      } else {
        if (from < 3) {
          await m.addColumn(reminders, reminders.recurrence);
          await m.addColumn(reminders, reminders.customRule);
        }
        if (from < 4) {
          await m.createTable(events);
        }
        if (from < 5) {
          await m.addColumn(focusSessions, focusSessions.status);
          await m.addColumn(focusSessions, focusSessions.pausedAt);
          await m.addColumn(focusSessions, focusSessions.accumulatedPausedMs);
          // Pre-migration rows predate `status` and were always either
          // fully ended or (in practice) never left running by the old
          // no-op FocusRepository-less scaffold — backfill deterministically
          // from `endedAt` rather than leaving the column default
          // ('running') on rows that are actually long since completed.
          await customStatement(
            "UPDATE focus_sessions SET status = 'completed' "
            'WHERE ended_at IS NOT NULL',
          );
        }
        if (from < 6) {
          await m.addColumn(reminders, reminders.category);
        }
        if (from < 7) {
          // `mood_entries` changes shape entirely — one-row-per-day
          // (`local_date` TEXT + `score` INT) becomes append-only
          // (`mood_level` TEXT + `recorded_at`/`created_at` DateTime), so
          // this can't be an `addColumn` step. Rename the old table aside,
          // create the new shape fresh, migrate each existing row across
          // (mapping its 1-5 `score` into the new `moodLevel` bucket,
          // `local_date` midnight into `recordedAt`/`createdAt`), then drop
          // the renamed original — preserves every pre-existing entry
          // rather than losing it to a destructive recreate.
          // Guarded rather than unconditional: some of this test suite's
          // synthetic pre-v7 fixtures only seed the tables relevant to what
          // they're individually testing (not a full v2/v3/v4/v5 schema),
          // so `mood_entries` may not exist yet on the connection this
          // branch runs against. A genuine pre-v7 install always has it
          // (created by the `from < 2` branch), so this is a no-op there.
          final moodTableExists = await customSelect(
            "SELECT 1 FROM sqlite_master WHERE type = 'table' "
            "AND name = 'mood_entries'",
          ).getSingleOrNull();
          if (moodTableExists != null) {
            await customStatement(
              'ALTER TABLE mood_entries RENAME TO mood_entries_v6',
            );
          }
          await m.createTable(moodEntries);
          if (moodTableExists != null) {
            // Row-by-row in Dart rather than a single SQL INSERT SELECT:
            // sqlite's `strftime('%s', local_date)` always treats the date
            // as UTC, but Drift decodes epoch-seconds columns back into
            // *local* DateTimes (`DateTime.fromMillisecondsSinceEpoch` with
            // no `isUtc` flag — see `SqlTypes._readDateTime`). Computing the
            // epoch via SQL would therefore round-trip to the wrong
            // wall-clock time on any non-UTC device;
            // `DateTime(y, m, d).millisecondsSinceEpoch` is local-aware and
            // round-trips correctly instead.
            final oldRows = await customSelect(
              'SELECT id, local_date, score, note FROM mood_entries_v6',
            ).get();
            for (final row in oldRows) {
              final id = row.read<String>('id');
              final localDate = row.read<String>('local_date');
              final score = row.read<int>('score');
              final note = row.readNullable<String>('note');
              final parts = localDate.split('-').map(int.parse).toList();
              final recordedAt = DateTime(parts[0], parts[1], parts[2]);
              final moodLevel = switch (score) {
                <= 1 => 'veryBad',
                2 => 'bad',
                3 => 'neutral',
                4 => 'good',
                _ => 'great',
              };
              await customStatement(
                'INSERT INTO mood_entries '
                '(id, mood_level, note, recorded_at, created_at) '
                'VALUES (?, ?, ?, ?, ?)',
                [
                  id,
                  moodLevel,
                  note,
                  recordedAt.millisecondsSinceEpoch ~/ 1000,
                  recordedAt.millisecondsSinceEpoch ~/ 1000,
                ],
              );
            }
            await customStatement('DROP TABLE mood_entries_v6');
          }
          await m.createTable(medications);
          await m.createTable(medicationOccurrences);
        }
        if (from < 8) {
          // Four brand-new, independent tables (Hydration/Sleep/Weight/
          // Activity) — no reshaping of any existing table, so a plain
          // `createTable` per table is sufficient; nothing here can affect
          // pre-existing Medication/Mood data.
          await m.createTable(hydrationEntries);
          await m.createTable(sleepEntries);
          await m.createTable(weightEntries);
          await m.createTable(dailyActivity);
        }
      }
    },
    beforeOpen: (details) async {
      // SQLite has FK enforcement off by default; without this, the
      // `onDelete: KeyAction.cascade` declared on HabitCompletions/ListItems
      // would be silently ignored.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
