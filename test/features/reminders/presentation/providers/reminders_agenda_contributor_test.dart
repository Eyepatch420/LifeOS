import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category_label.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_agenda_contributor.dart';

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late RemindersRepository repository;
  late RemindersAgendaContributor contributor;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    repository = RemindersRepository(db.remindersDao, eventBus);
    contributor = RemindersAgendaContributor(repository);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('contributes an AgendaEntry per non-completed reminder', () async {
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1, 9),
      isUrgent: true,
    );
    await repository.create(
      id: 'r2',
      title: 'Walk',
      dueAt: DateTime(2026, 1, 1, 18),
      isUrgent: false,
    );

    final entries = await contributor.contributions().first;

    expect(entries, hasLength(2));
    final entry = entries.firstWhere((e) => e.id == 'r1');
    expect(entry.sourceModule, 'reminders');
    expect(entry.sourceId, 'r1');
    expect(entry.title, 'Pay rent');
    expect(entry.time, DateTime(2026, 1, 1, 9));
    expect(entry.isUrgent, isTrue);
  });

  test('excludes completed reminders from contributions', () async {
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await repository.setCompleted('r1', true);

    final entries = await contributor.contributions().first;

    expect(entries, isEmpty);
  });

  test('maps reminder category to its icon, falling back to the category '
      'color when not urgent', () async {
    await repository.create(
      id: 'r1',
      title: 'Take medicine',
      dueAt: DateTime(2026, 1, 1, 9),
      isUrgent: false,
      category: ReminderCategory.medicine,
    );

    final entries = await contributor.contributions().first;

    final entry = entries.single;
    expect(entry.icon, reminderCategoryIcon(ReminderCategory.medicine));
    expect(entry.dotColor, reminderCategoryColor(ReminderCategory.medicine));
  });

  test('an urgent reminder keeps the red dot regardless of category', () async {
    await repository.create(
      id: 'r1',
      title: 'Take medicine',
      dueAt: DateTime(2026, 1, 1, 9),
      isUrgent: true,
      category: ReminderCategory.medicine,
    );

    final entries = await contributor.contributions().first;

    expect(entries.single.dotColor, Colors.red);
  });

  test('dismiss marks the reminder completed', () async {
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );

    await contributor.dismiss('r1');

    final reminder = await repository.getById('r1');
    expect(reminder!.isCompleted, isTrue);
  });
}
