import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  group('HydrationEntriesDao', () {
    test('insert adds a new entry', () async {
      final now = DateTime(2026, 7, 16, 9);
      await db.hydrationEntriesDao.insert(
        HydrationEntriesCompanion.insert(
          id: 'h1',
          amountMl: 250,
          recordedAt: now,
          createdAt: now,
        ),
      );

      final entry = await db.hydrationEntriesDao.getById('h1');
      expect(entry, isNotNull);
      expect(entry!.amountMl, 250);
    });

    test('watchBetween returns only entries within range', () async {
      await db.hydrationEntriesDao.insert(
        HydrationEntriesCompanion.insert(
          id: 'h1',
          amountMl: 250,
          recordedAt: DateTime(2026, 7, 15, 12),
          createdAt: DateTime(2026, 7, 15, 12),
        ),
      );
      await db.hydrationEntriesDao.insert(
        HydrationEntriesCompanion.insert(
          id: 'h2',
          amountMl: 500,
          recordedAt: DateTime(2026, 7, 16, 8),
          createdAt: DateTime(2026, 7, 16, 8),
        ),
      );

      final between = await db.hydrationEntriesDao
          .watchBetween(DateTime(2026, 7, 16), DateTime(2026, 7, 17))
          .first;
      expect(between.map((e) => e.id), ['h2']);
    });

    test('deleteById removes the entry', () async {
      await db.hydrationEntriesDao.insert(
        HydrationEntriesCompanion.insert(
          id: 'h1',
          amountMl: 250,
          recordedAt: DateTime(2026, 7, 16),
          createdAt: DateTime(2026, 7, 16),
        ),
      );
      await db.hydrationEntriesDao.deleteById('h1');

      expect(await db.hydrationEntriesDao.watchAll().first, isEmpty);
    });

    test('updateFields overwrites the amount', () async {
      await db.hydrationEntriesDao.insert(
        HydrationEntriesCompanion.insert(
          id: 'h1',
          amountMl: 250,
          recordedAt: DateTime(2026, 7, 16),
          createdAt: DateTime(2026, 7, 16),
        ),
      );
      await db.hydrationEntriesDao.updateFields(
        'h1',
        const HydrationEntriesCompanion(amountMl: Value(500)),
      );

      final entry = await db.hydrationEntriesDao.getById('h1');
      expect(entry!.amountMl, 500);
    });
  });

  group('SleepEntriesDao', () {
    test('insert adds a new overnight record', () async {
      await db.sleepEntriesDao.insert(
        SleepEntriesCompanion.insert(
          id: 's1',
          bedtime: DateTime(2026, 7, 15, 23),
          wakeTime: DateTime(2026, 7, 16, 7),
          createdAt: DateTime(2026, 7, 16, 7),
        ),
      );

      final entry = await db.sleepEntriesDao.getById('s1');
      expect(entry, isNotNull);
      expect(
        entry!.wakeTime.difference(entry.bedtime),
        const Duration(hours: 8),
      );
    });

    test('watchAll orders by wakeTime descending', () async {
      await db.sleepEntriesDao.insert(
        SleepEntriesCompanion.insert(
          id: 's1',
          bedtime: DateTime(2026, 7, 13, 23),
          wakeTime: DateTime(2026, 7, 14, 7),
          createdAt: DateTime(2026, 7, 14, 7),
        ),
      );
      await db.sleepEntriesDao.insert(
        SleepEntriesCompanion.insert(
          id: 's2',
          bedtime: DateTime(2026, 7, 15, 23),
          wakeTime: DateTime(2026, 7, 16, 7),
          createdAt: DateTime(2026, 7, 16, 7),
        ),
      );

      final all = await db.sleepEntriesDao.watchAll().first;
      expect(all.map((e) => e.id), ['s2', 's1']);
    });

    test('deleteById removes the record', () async {
      await db.sleepEntriesDao.insert(
        SleepEntriesCompanion.insert(
          id: 's1',
          bedtime: DateTime(2026, 7, 15, 23),
          wakeTime: DateTime(2026, 7, 16, 7),
          createdAt: DateTime(2026, 7, 16, 7),
        ),
      );
      await db.sleepEntriesDao.deleteById('s1');

      expect(await db.sleepEntriesDao.watchAll().first, isEmpty);
    });

    test('updateFields overwrites quality', () async {
      await db.sleepEntriesDao.insert(
        SleepEntriesCompanion.insert(
          id: 's1',
          bedtime: DateTime(2026, 7, 15, 23),
          wakeTime: DateTime(2026, 7, 16, 7),
          createdAt: DateTime(2026, 7, 16, 7),
        ),
      );
      await db.sleepEntriesDao.updateFields(
        's1',
        const SleepEntriesCompanion(quality: Value('great')),
      );

      final entry = await db.sleepEntriesDao.getById('s1');
      expect(entry!.quality, 'great');
    });
  });

  group('WeightEntriesDao', () {
    test('insert adds a decimal weight entry', () async {
      await db.weightEntriesDao.insert(
        WeightEntriesCompanion.insert(
          id: 'w1',
          weightKg: 64.25,
          recordedAt: DateTime(2026, 7, 16),
          createdAt: DateTime(2026, 7, 16),
        ),
      );

      final entry = await db.weightEntriesDao.getById('w1');
      expect(entry!.weightKg, 64.25);
    });

    test('watchAll orders by recordedAt descending', () async {
      await db.weightEntriesDao.insert(
        WeightEntriesCompanion.insert(
          id: 'w1',
          weightKg: 65,
          recordedAt: DateTime(2026, 7, 10),
          createdAt: DateTime(2026, 7, 10),
        ),
      );
      await db.weightEntriesDao.insert(
        WeightEntriesCompanion.insert(
          id: 'w2',
          weightKg: 64.2,
          recordedAt: DateTime(2026, 7, 16),
          createdAt: DateTime(2026, 7, 16),
        ),
      );

      final all = await db.weightEntriesDao.watchAll().first;
      expect(all.map((e) => e.id), ['w2', 'w1']);
    });

    test('deleteById removes the entry', () async {
      await db.weightEntriesDao.insert(
        WeightEntriesCompanion.insert(
          id: 'w1',
          weightKg: 64,
          recordedAt: DateTime(2026, 7, 16),
          createdAt: DateTime(2026, 7, 16),
        ),
      );
      await db.weightEntriesDao.deleteById('w1');

      expect(await db.weightEntriesDao.watchAll().first, isEmpty);
    });
  });

  group('DailyActivityDao', () {
    test('upsert inserts a new day', () async {
      await db.dailyActivityDao.upsert(
        DailyActivityCompanion.insert(
          id: '2026-07-16',
          steps: 7842,
          updatedAt: DateTime(2026, 7, 16, 20),
        ),
      );

      final day = await db.dailyActivityDao.getByDayKey('2026-07-16');
      expect(day!.steps, 7842);
    });

    test('upsert on the same day key updates in place, not append', () async {
      await db.dailyActivityDao.upsert(
        DailyActivityCompanion.insert(
          id: '2026-07-16',
          steps: 3000,
          updatedAt: DateTime(2026, 7, 16, 12),
        ),
      );
      await db.dailyActivityDao.upsert(
        DailyActivityCompanion.insert(
          id: '2026-07-16',
          steps: 7842,
          updatedAt: DateTime(2026, 7, 16, 20),
        ),
      );

      final all = await db.dailyActivityDao.watchAll().first;
      expect(all, hasLength(1));
      expect(all.single.steps, 7842);
    });

    test('watchRecent limits and orders by day key descending', () async {
      await db.dailyActivityDao.upsert(
        DailyActivityCompanion.insert(
          id: '2026-07-14',
          steps: 5000,
          updatedAt: DateTime(2026, 7, 14),
        ),
      );
      await db.dailyActivityDao.upsert(
        DailyActivityCompanion.insert(
          id: '2026-07-15',
          steps: 6000,
          updatedAt: DateTime(2026, 7, 15),
        ),
      );
      await db.dailyActivityDao.upsert(
        DailyActivityCompanion.insert(
          id: '2026-07-16',
          steps: 7842,
          updatedAt: DateTime(2026, 7, 16),
        ),
      );

      final recent = await db.dailyActivityDao.watchRecent(2).first;
      expect(recent.map((e) => e.id), ['2026-07-16', '2026-07-15']);
    });
  });
}
