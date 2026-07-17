import 'package:drift/drift.dart';

/// Persisted feed entries produced by the NotificationEngine from
/// `DomainEvent`s (see `core/events/`). `sourceModule`/`sourceId` let a tap
/// navigate back to the originating feature without this table depending on
/// any feature's types.
///
/// `@DataClassName` avoids Drift generating a data class literally named
/// `Notification`, which would shadow Flutter's own `Notification` widget
/// type.
@DataClassName('NotificationRecord')
class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get sourceModule => text()();
  TextColumn get sourceId => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get readAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
