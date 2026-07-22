import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/hydration/presentation/screens/hydration_screen.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

void main() {
  Future<ProviderContainer> pump(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = PreferencesService(await SharedPreferences.getInstance());
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
          path: '/hydration',
          builder: (context, state) => const HydrationScreen(),
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
          preferencesServiceProvider.overrideWithValue(prefs),
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
    router.push('/hydration');
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('empty state shows 0/goal and quick-add actions', (tester) async {
    await pump(tester);

    expect(find.text('0.0 / 2.5 L'), findsOneWidget);
    expect(find.text('No water logged today'), findsOneWidget);
    expect(find.text('+250 ml'), findsOneWidget);
    expect(find.text('+500 ml'), findsOneWidget);
  });

  testWidgets('tapping a quick-add chip logs an entry and updates the total', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('+250 ml'));
    await tester.pumpAndSettle();

    // Assert via the rendered UI, not a second independent query against
    // the DAO's stream — the widget tree already holds a live listener on
    // `hydrationDashboardProvider`'s `watchToday()` stream, and issuing a
    // second query against the same Drift connection while that listener
    // is open deadlocks it (same class of bug documented on
    // `MedicationsRepository.watchTodayOccurrences`'s doc comment).
    expect(find.text('0.3 / 2.5 L'), findsOneWidget);
    expect(find.text('250 ml'), findsOneWidget);
  });
}
