import 'package:drift/drift.dart';

/// `endedAt` is null while a session is running/paused. `plannedMinutes`
/// backs progress UI; `kind` distinguishes focus/break sessions without a
/// separate table.
///
/// `status` (`running`/`paused`/`completed`/`cancelled`) plus `pausedAt`/
/// `accumulatedPausedMs` make the persisted timeline the sole source of
/// truth for elapsed/remaining time — see `FocusSession.elapsedAt` in
/// `features/focus/domain/entities/focus_session.dart`. `pausedAt` is the
/// instant the CURRENT pause began (null unless `status == paused`);
/// `accumulatedPausedMs` is the total paused duration from all PRIOR
/// pause/resume cycles in this session, so elapsed time at any instant is
/// always `now - startedAt - accumulatedPausedMs - (currently paused ?
/// now - pausedAt : 0)`, never a value that depends on a running in-memory
/// countdown having actually ticked.
class FocusSessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get plannedMinutes => integer()();
  TextColumn get kind => text()();
  TextColumn get status => text().withDefault(const Constant('running'))();
  DateTimeColumn get pausedAt => dateTime().nullable()();
  IntColumn get accumulatedPausedMs =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
