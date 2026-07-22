import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/weight/presentation/providers/weight_dashboard_provider.dart';
import 'package:lifeos/features/weight/presentation/screens/weight_screen.dart';

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
          path: '/weight',
          builder: (context, state) => const WeightScreen(),
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
    router.push('/weight');
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('empty state shows no weight recorded', (tester) async {
    await pump(tester);

    expect(find.text('No weight recorded yet'), findsOneWidget);
  });

  testWidgets('a logged weight shows as the latest measurement', (
    tester,
  ) async {
    final container = await pump(tester);

    await container
        .read(weightRepositoryProvider)
        .log(id: 'w1', weightKg: 64.2);
    await tester.pumpAndSettle();

    expect(find.text('64.2 kg'), findsWidgets);
  });
}
