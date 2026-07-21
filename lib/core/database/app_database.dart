import 'package:drift/drift.dart';
import 'package:lifeos/core/database/daos/events_dao.dart';
import 'package:lifeos/core/database/daos/expenses_dao.dart';
import 'package:lifeos/core/database/daos/focus_sessions_dao.dart';
import 'package:lifeos/core/database/daos/habits_dao.dart';
import 'package:lifeos/core/database/daos/lists_dao.dart';
import 'package:lifeos/core/database/daos/mood_entries_dao.dart';
import 'package:lifeos/core/database/daos/notes_dao.dart';
import 'package:lifeos/core/database/daos/notifications_dao.dart';
import 'package:lifeos/core/database/daos/reminders_dao.dart';
import 'package:lifeos/core/database/database_connection.dart';
import 'package:lifeos/core/database/tables/events_table.dart';
import 'package:lifeos/core/database/tables/expenses_table.dart';
import 'package:lifeos/core/database/tables/focus_sessions_table.dart';
import 'package:lifeos/core/database/tables/habits_table.dart';
import 'package:lifeos/core/database/tables/lists_table.dart';
import 'package:lifeos/core/database/tables/mood_entries_table.dart';
import 'package:lifeos/core/database/tables/notes_table.dart';
import 'package:lifeos/core/database/tables/notifications_table.dart';
import 'package:lifeos/core/database/tables/reminders_table.dart';

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
  int get schemaVersion => 6;

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
