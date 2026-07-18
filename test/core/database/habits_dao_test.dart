import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Future<void> insertHabit(String id) => db.habitsDao.upsert(
    HabitsCompanion.insert(
      id: id,
      title: 'Habit $id',
      targetFrequency: 'Daily',
      icon: 'star',
      createdAt: DateTime.now(),
    ),
  );

  test('watchAll excludes archived habits', () async {
    await insertHabit('h1');
    await insertHabit('h2');
    await db.habitsDao.archive('h2');

    final all = await db.habitsDao.watchAll().first;
    expect(all.map((h) => h.id), ['h1']);
  });

  test('toggleCompletion inserts then removes the same day\'s row', () async {
    await insertHabit('h1');
    var idCounter = 0;

    await db.habitsDao.toggleCompletion(
      'h1',
      '2026-07-16',
      () => 'c${idCounter++}',
    );
    var completions = await db.habitsDao.watchCompletions('h1').first;
    expect(completions, hasLength(1));
    expect(completions.single.localDate, '2026-07-16');

    await db.habitsDao.toggleCompletion(
      'h1',
      '2026-07-16',
      () => 'c${idCounter++}',
    );
    completions = await db.habitsDao.watchCompletions('h1').first;
    expect(completions, isEmpty);
  });

  test('toggleCompletion for different days creates separate rows', () async {
    await insertHabit('h1');
    var idCounter = 0;

    await db.habitsDao.toggleCompletion(
      'h1',
      '2026-07-15',
      () => 'c${idCounter++}',
    );
    await db.habitsDao.toggleCompletion(
      'h1',
      '2026-07-16',
      () => 'c${idCounter++}',
    );

    final completions = await db.habitsDao.watchCompletions('h1').first;
    expect(completions, hasLength(2));
  });

  test('deleting a habit cascades to its completions', () async {
    await insertHabit('h1');
    await db.habitsDao.toggleCompletion('h1', '2026-07-16', () => 'c1');

    await db.customStatement('DELETE FROM habits WHERE id = ?', ['h1']);

    final completions = await db.habitsDao.watchCompletions('h1').first;
    expect(completions, isEmpty);
  });

  test('setCompletedForDate(completed: true) is idempotent', () async {
    await insertHabit('h1');
    var idCounter = 0;

    await db.habitsDao.setCompletedForDate(
      'h1',
      '2026-07-16',
      completed: true,
      newId: () => 'c${idCounter++}',
    );
    await db.habitsDao.setCompletedForDate(
      'h1',
      '2026-07-16',
      completed: true,
      newId: () => 'c${idCounter++}',
    );

    final completions = await db.habitsDao.watchCompletions('h1').first;
    expect(completions, hasLength(1));
  });

  test('setCompletedForDate(completed: false) is idempotent', () async {
    await insertHabit('h1');
    var idCounter = 0;

    await db.habitsDao.setCompletedForDate(
      'h1',
      '2026-07-16',
      completed: false,
      newId: () => 'c${idCounter++}',
    );
    await db.habitsDao.setCompletedForDate(
      'h1',
      '2026-07-16',
      completed: false,
      newId: () => 'c${idCounter++}',
    );

    final completions = await db.habitsDao.watchCompletions('h1').first;
    expect(completions, isEmpty);
  });

  test('setCompletedForDate can undo a prior completion', () async {
    await insertHabit('h1');
    var idCounter = 0;

    await db.habitsDao.setCompletedForDate(
      'h1',
      '2026-07-16',
      completed: true,
      newId: () => 'c${idCounter++}',
    );
    await db.habitsDao.setCompletedForDate(
      'h1',
      '2026-07-16',
      completed: false,
      newId: () => 'c${idCounter++}',
    );

    final completions = await db.habitsDao.watchCompletions('h1').first;
    expect(completions, isEmpty);
  });
}
