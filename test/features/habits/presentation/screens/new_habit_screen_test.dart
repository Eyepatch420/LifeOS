import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart' hide Habit;
import 'package:lifeos/features/habits/domain/entities/habit.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/features/habits/presentation/screens/new_habit_screen.dart';

void main() {
  Future<ProviderContainer> pump(WidgetTester tester) async {
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
          path: '/new-habit',
          builder: (context, state) => const NewHabitScreen(),
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
    router.push('/new-habit');
    await tester.pumpAndSettle();
    return container;
  }

  /// A one-shot read of the current habit list without establishing a
  /// fresh `.watchAll().first` subscription — a bare `.first` read (with
  /// no listener already held open) on a Drift query stream was observed
  /// to stall the test runner isolate via a pending detach `Timer`, the
  /// same gotcha documented in
  /// `new_reminder_screen_test.dart`'s `pump()` doc comment. Reading
  /// through an already-live provider listener sidesteps it.
  Future<List<Habit>> currentHabits(ProviderContainer container) async {
    final sub = container.listen(_habitsListProvider, (_, _) {});
    await container.read(_habitsListProvider.future);
    final value = container.read(_habitsListProvider).value!;
    sub.close();
    return value;
  }

  testWidgets('renders a title field, schedule chips, and a Save Habit CTA', (
    tester,
  ) async {
    await pump(tester);

    expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
    expect(find.text('Save Habit'), findsOneWidget);
  });

  testWidgets('blank title shows a validation error and does not save', (
    tester,
  ) async {
    final container = await pump(tester);

    await tester.tap(find.text('Save Habit'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(await currentHabits(container), isEmpty);
  });

  testWidgets('selecting Weekly reveals weekday chips', (tester) async {
    await pump(tester);

    expect(find.text('Mon'), findsNothing);

    await tester.tap(find.text('Weekly'));
    await tester.pump();

    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget);
  });

  testWidgets(
    'Weekly with no selected day shows a validation error and does not save',
    (tester) async {
      final container = await pump(tester);

      await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Gym');
      await tester.tap(find.text('Weekly'));
      await tester.pump();
      await tester.tap(find.text('Save Habit'));
      await tester.pumpAndSettle();

      expect(find.text('Choose at least one day'), findsOneWidget);
      expect(await currentHabits(container), isEmpty);
    },
  );

  testWidgets('saving a valid daily habit persists it and pops', (
    tester,
  ) async {
    final container = await pump(tester);

    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Morning Walk',
    );
    await tester.tap(find.text('Save Habit'));
    await tester.pumpAndSettle();

    final habits = await currentHabits(container);
    expect(habits, hasLength(1));
    expect(habits.single.title, 'Morning Walk');
    expect(habits.single.schedule.isDaily, isTrue);
  });

  testWidgets('saving a valid weekly habit persists the selected weekdays', (
    tester,
  ) async {
    final container = await pump(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Gym');
    await tester.tap(find.text('Weekly'));
    await tester.pump();
    await tester.tap(find.text('Mon'));
    await tester.tap(find.text('Wed'));
    await tester.pump();
    await tester.tap(find.text('Save Habit'));
    await tester.pumpAndSettle();

    final habits = await currentHabits(container);
    expect(habits.single.schedule.weekdays, {1, 3});
  });
}

final _habitsListProvider = StreamProvider.autoDispose<List<Habit>>((ref) {
  return ref.watch(habitsRepositoryProvider).watchAll();
});
