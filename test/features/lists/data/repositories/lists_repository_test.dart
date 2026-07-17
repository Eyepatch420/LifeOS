import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/lists/data/repositories/lists_repository.dart';
import 'package:lifeos/features/lists/domain/events/list_events.dart';

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late ListsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    repository = ListsRepository(db.listsDao, eventBus);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('watchAll is empty before any list is created', () async {
    expect(await repository.watchAll().first, isEmpty);
  });

  test('createList adds a list with no items', () async {
    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');

    final list = await repository.watchById('l1').first;
    expect(list, isNotNull);
    expect(list!.title, 'Groceries');
    expect(list.items, isEmpty);
  });

  test('createList emits a ListCreated event', () async {
    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await pumpEventQueue();

    expect(events, hasLength(1));
    expect(events.single, isA<ListCreated>());
    expect(events.single.sourceId, 'l1');
    await sub.cancel();
  });

  test('addItem appends an item to the list', () async {
    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await repository.addItem(
      id: 'i1',
      listId: 'l1',
      label: 'Milk',
      sortOrder: 0,
    );

    final list = await repository.watchById('l1').first;
    expect(list!.items, hasLength(1));
    expect(list.items.single.label, 'Milk');
    expect(list.items.single.isDone, isFalse);
  });

  test('setItemDone toggles completion', () async {
    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await repository.addItem(
      id: 'i1',
      listId: 'l1',
      label: 'Milk',
      sortOrder: 0,
    );
    await repository.setItemDone('i1', true);

    final list = await repository.watchById('l1').first;
    expect(list!.items.single.isDone, isTrue);
  });

  test('deleteItem removes just that item', () async {
    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await repository.addItem(
      id: 'i1',
      listId: 'l1',
      label: 'Milk',
      sortOrder: 0,
    );
    await repository.addItem(
      id: 'i2',
      listId: 'l1',
      label: 'Eggs',
      sortOrder: 1,
    );

    await repository.deleteItem('i1');

    final list = await repository.watchById('l1').first;
    expect(list!.items.map((i) => i.id), ['i2']);
  });

  test('reorderItems rewrites sortOrder to match the given order', () async {
    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await repository.addItem(
      id: 'i1',
      listId: 'l1',
      label: 'Milk',
      sortOrder: 0,
    );
    await repository.addItem(
      id: 'i2',
      listId: 'l1',
      label: 'Eggs',
      sortOrder: 1,
    );

    await repository.reorderItems(['i2', 'i1']);

    final list = await repository.watchById('l1').first;
    expect(list!.items.map((i) => i.id), ['i2', 'i1']);
  });

  test('archiveList excludes the list from watchAll', () async {
    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await repository.archiveList('l1', true);

    expect(await repository.watchAll().first, isEmpty);
  });

  test('deleteList (soft delete) excludes the list from watchAll', () async {
    await repository.createList(id: 'l1', title: 'Groceries', kind: 'shopping');
    await repository.deleteList('l1');

    expect(await repository.watchAll().first, isEmpty);
  });
}
