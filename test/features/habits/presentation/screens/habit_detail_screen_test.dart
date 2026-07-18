import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart' hide Habit;
import 'package:lifeos/features/habits/domain/entities/habit.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/features/habits/presentation/screens/habit_detail_screen.dart';

final _habitsListProvider = StreamProvider.autoDispose<List<Habit>>((ref) {
  return ref.watch(habitsRepositoryProvider).watchAll();
});

void main() {
  /// A one-shot read of the current habit list without establishing a
  /// fresh `.watchAll().first` subscription — see
  /// `new_habit_screen_test.dart`'s identical helper doc comment for why a
  /// bare `.first` read can stall the test runner isolate.
  Future<List<Habit>> currentHabits(ProviderContainer container) async {
    final sub = container.listen(_habitsListProvider, (_, _) {});
    await container.read(_habitsListProvider.future);
    final value = container.read(_habitsListProvider).value!;
    sub.close();
    return value;
  }

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    required String habitId,
  }) async {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    late ProviderContainer container;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/habit',
          builder: (context, state) => HabitDetailScreen(habitId: habitId),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();
    router.push('/habit');
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('a stale/nonexistent habitId shows an empty state', (
    tester,
  ) async {
    await pump(tester, habitId: 'missing');

    expect(find.text('This habit no longer exists'), findsOneWidget);
  });

  testWidgets('shows title, schedule, and streak for an existing habit', (
    tester,
  ) async {
    final container = await pump(tester, habitId: 'h1');
    await container
        .read(habitsRepositoryProvider)
        .create(
          id: 'h1',
          title: 'Morning Walk',
          schedule: const HabitSchedule.daily(),
          icon: 'walk',
        );
    await tester.pumpAndSettle();

    expect(find.text('Morning Walk'), findsWidgets);
    expect(find.text('Daily'), findsOneWidget);
    expect(find.textContaining('day streak'), findsOneWidget);
  });

  testWidgets('Mark Done completes today and updates the streak display', (
    tester,
  ) async {
    final container = await pump(tester, habitId: 'h1');
    await container
        .read(habitsRepositoryProvider)
        .create(
          id: 'h1',
          title: 'Read',
          schedule: const HabitSchedule.daily(),
          icon: 'book',
        );
    await tester.pumpAndSettle();

    expect(find.text('Mark Done'), findsOneWidget);

    await tester.tap(find.text('Mark Done'));
    await tester.pumpAndSettle();

    expect(find.text('Undo Completion'), findsOneWidget);
    expect(find.text('Completed today'), findsOneWidget);
  });

  testWidgets('Undo Completion reverses a completion', (tester) async {
    final container = await pump(tester, habitId: 'h1');
    final repository = container.read(habitsRepositoryProvider);
    await repository.create(
      id: 'h1',
      title: 'Read',
      schedule: const HabitSchedule.daily(),
      icon: 'book',
    );
    await repository.setCompletedForDate('h1', DateTime.now(), completed: true);
    await tester.pumpAndSettle();

    expect(find.text('Undo Completion'), findsOneWidget);

    await tester.tap(find.text('Undo Completion'));
    await tester.pumpAndSettle();

    expect(find.text('Mark Done'), findsOneWidget);
  });

  testWidgets('editing title and schedule persists the change', (tester) async {
    final container = await pump(tester, habitId: 'h1');
    await container
        .read(habitsRepositoryProvider)
        .create(
          id: 'h1',
          title: 'Old Title',
          schedule: const HabitSchedule.daily(),
          icon: 'star',
        );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'New Title',
    );
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    final habit = await container.read(habitsRepositoryProvider).getById('h1');
    expect(habit!.title, 'New Title');
  });

  testWidgets('deleting a habit archives it and pops', (tester) async {
    final container = await pump(tester, habitId: 'h1');
    await container
        .read(habitsRepositoryProvider)
        .create(
          id: 'h1',
          title: 'Delete me',
          schedule: const HabitSchedule.daily(),
          icon: 'star',
        );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    final active = await currentHabits(container);
    expect(active, isEmpty);
  });
}
