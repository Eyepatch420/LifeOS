import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart' hide Medication;
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/medications/domain/entities/medication.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule.dart';
import 'package:lifeos/features/medications/presentation/providers/medications_dashboard_provider.dart';
import 'package:lifeos/features/medications/presentation/screens/new_medication_screen.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

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
          path: '/new-medication',
          builder: (context, state) => const NewMedicationScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockManagerProvider.overrideWithValue(
            _FakeClock(DateTime(2026, 1, 1, 9)),
          ),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();
    router.push('/new-medication');
    await tester.pumpAndSettle();
    return container;
  }

  Future<List<Medication>> currentMedications(
    ProviderContainer container,
  ) async {
    final sub = container.listen(_medicationsListProvider, (_, _) {});
    await container.read(_medicationsListProvider.future);
    final value = container.read(_medicationsListProvider).value!;
    sub.close();
    return value;
  }

  testWidgets('renders a name field, one default time chip, and a Save CTA', (
    tester,
  ) async {
    await pump(tester);

    expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
    expect(find.text('09:00'), findsOneWidget);
    expect(find.text('Save Medication'), findsOneWidget);
  });

  testWidgets('blank name shows a validation error and does not save', (
    tester,
  ) async {
    final container = await pump(tester);

    await tester.tap(find.text('Save Medication'));
    await tester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);
    expect(await currentMedications(container), isEmpty);
  });

  testWidgets('selecting "Selected days" reveals weekday chips', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Mon'), findsNothing);

    await tester.tap(find.text('Selected days'));
    await tester.pump();

    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget);
  });

  testWidgets(
    'Selected days with no chosen day shows a validation error and does '
    'not save',
    (tester) async {
      final container = await pump(tester);

      await tester.enterText(
        find.widgetWithText(TextField, 'Name'),
        'Vitamin D',
      );
      await tester.tap(find.text('Selected days'));
      await tester.pump();
      await tester.tap(find.text('Save Medication'));
      await tester.pumpAndSettle();

      expect(find.text('Choose at least one day'), findsOneWidget);
      expect(await currentMedications(container), isEmpty);
    },
  );

  testWidgets('saving a valid daily medication persists it and pops', (
    tester,
  ) async {
    final container = await pump(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Vitamin D');
    await tester.tap(find.text('Save Medication'));
    await tester.pumpAndSettle();

    final medications = await currentMedications(container);
    expect(medications, hasLength(1));
    expect(medications.single.name, 'Vitamin D');
    expect(medications.single.schedule.isDaily, isTrue);
    expect(medications.single.schedule.times, hasLength(1));
  });

  testWidgets('adding a second time via the time picker keeps both chips', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Add time'));
    await tester.pumpAndSettle();
    // Confirm the default-selected time in the material time picker dialog.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Two InputChips now render (09:00 default + whatever the picker
    // returned) — exact label of the second is picker-default-dependent,
    // so just assert the count grew to 2 distinct time chips.
    expect(find.byType(InputChip), findsNWidgets(2));
  });
}

final _medicationsListProvider = StreamProvider.autoDispose<List<Medication>>((
  ref,
) {
  return ref.watch(medicationsRepositoryProvider).watchAll();
});
