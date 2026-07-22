import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/sleep/presentation/providers/sleep_dashboard_provider.dart';
import 'package:lifeos/features/sleep/presentation/screens/sleep_screen.dart';

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
          path: '/sleep',
          builder: (context, state) => const SleepScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockManagerProvider.overrideWithValue(
            _FakeClock(DateTime(2026, 1, 2, 8)),
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
    router.push('/sleep');
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('empty state shows no sleep logged', (tester) async {
    await pump(tester);

    expect(find.text('No sleep logged yet'), findsOneWidget);
    expect(find.text('No sleep logged'), findsOneWidget);
  });

  testWidgets('a logged sleep entry shows in the dashboard summary', (
    tester,
  ) async {
    final container = await pump(tester);

    await container
        .read(sleepRepositoryProvider)
        .log(
          id: 's1',
          bedtime: DateTime(2026, 1, 1, 23),
          wakeTime: DateTime(2026, 1, 2, 7),
        );
    await tester.pumpAndSettle();

    expect(find.text('8h 0m'), findsWidgets);
  });
}
