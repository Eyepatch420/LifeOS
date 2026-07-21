import 'package:drift/drift.dart';

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  DateTimeColumn get dueAt => dateTime()();
  BoolColumn get isUrgent => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// The recurrence rule name (`none`/`daily`/`weekdays`/`weekly`/`monthly`/
  /// `yearly`/`custom` — see `features/reminders/domain/entities/recurrence_rule.dart`),
  /// stored as text rather than an int index so a future enum reordering
  /// never silently corrupts existing rows. Added schema v3 alongside
  /// [customRule] so the domain model can support the full recurrence
  /// taxonomy from day one — only `none`/`daily` are reachable from the
  /// first-pass UI, but the schema never needs a second migration to add
  /// the rest.
  TextColumn get recurrence => text().withDefault(const Constant('none'))();

  /// Reserved for a future rule-language (e.g. an RRULE-like string or
  /// JSON) backing `RecurrenceRule.custom`. Unused by any UI in this pass.
  TextColumn get customRule => text().nullable()();

  /// The category name (`medicine`/`meeting`/`work`/... — see
  /// `features/reminders/domain/entities/reminder_category.dart`), stored
  /// as text rather than an int index so a future enum reordering never
  /// silently corrupts existing rows. Added schema v6; existing rows
  /// backfill to `other` via the column default.
  TextColumn get category => text().withDefault(const Constant('other'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
