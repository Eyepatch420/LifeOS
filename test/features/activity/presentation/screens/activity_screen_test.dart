import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/activity/presentation/providers/activity_dashboard_provider.dart';
import 'package:lifeos/features/activity/presentation/screens/activity_screen.dart';
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
          path: '/activity',
          builder: (context, state) => const ActivityScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockManagerProvider.overrideWithValue(
            _FakeClock(DateTime(2026, 1, 3, 9)),
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
    router.push('/activity');
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('empty state shows 0 steps against the default goal', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('0 / 10000 steps'), findsOneWidget);
    expect(find.text('No activity recorded today'), findsOneWidget);
  });

  testWidgets('updating steps shows the new progress', (tester) async {
    final container = await pump(tester);

    await container.read(activityRepositoryProvider).setTodaySteps(steps: 7842);
    await tester.pumpAndSettle();

    expect(find.text('7842 / 10000 steps'), findsOneWidget);
  });
}
