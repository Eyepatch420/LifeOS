import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/health/presentation/screens/health_overview_screen.dart';
import 'package:lifeos/features/hydration/presentation/providers/hydration_dashboard_provider.dart';
import 'package:lifeos/features/mood/domain/entities/mood_level.dart';
import 'package:lifeos/features/mood/presentation/providers/mood_dashboard_provider.dart';
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
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: HealthOverviewScreen()),
        ),
        GoRoute(
          path: '/hydration',
          name: RouteNames.hydration,
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/sleep',
          name: RouteNames.sleep,
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/weight',
          name: RouteNames.weight,
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/activity',
          name: RouteNames.activity,
          builder: (context, state) => const SizedBox(),
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
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('all-empty state shows honest placeholders for every domain', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Medication'), findsOneWidget);
    expect(find.text('Mood'), findsOneWidget);
    expect(find.text('Hydration'), findsOneWidget);
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('No water logged today'), findsOneWidget);
    expect(find.text('No sleep logged'), findsOneWidget);
    expect(find.text('No weight recorded yet'), findsOneWidget);
    expect(find.text('No activity recorded today'), findsOneWidget);
  });

  testWidgets('populated Mood/Hydration data renders real values, not mocks', (
    tester,
  ) async {
    final container = await pump(tester);

    await container
        .read(moodRepositoryProvider)
        .log(id: 'm1', level: MoodLevel.great);
    await container
        .read(hydrationRepositoryProvider)
        .log(id: 'h1', amountMl: 500);
    await tester.pumpAndSettle();

    expect(find.text('Great'), findsOneWidget);
    expect(find.text('0.5 / 2.5 L'), findsOneWidget);
  });

  testWidgets('tapping the Hydration card navigates to the Hydration route', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Hydration'));
    await tester.pumpAndSettle();

    expect(find.byType(HealthOverviewScreen), findsNothing);
  });
}
