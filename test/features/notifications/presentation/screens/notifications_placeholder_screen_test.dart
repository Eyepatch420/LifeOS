import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/notifications/presentation/screens/notifications_placeholder_screen.dart';

void main() {
  Future<AppDatabase> pump(
    WidgetTester tester, {
    List<NotificationsCompanion> seed = const [],
  }) async {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    for (final row in seed) {
      await db.notificationsDao.insert(row);
    }

    final router = GoRouter(
      initialLocation: '/notifications',
      routes: [
        GoRoute(
          path: '/notifications',
          name: RouteNames.notifications,
          builder: (context, state) => const NotificationsPlaceholderScreen(),
        ),
        GoRoute(
          path: '/reminders/:reminderId',
          name: RouteNames.reminderDetail,
          builder: (context, state) => Scaffold(
            body: Text('Reminder ${state.pathParameters['reminderId']}'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return db;
  }

  testWidgets('shows an empty state when no notification has ever been '
      'scheduled', (tester) async {
    await pump(tester);

    expect(find.text('No notifications yet'), findsOneWidget);
  });

  testWidgets('renders persisted feed rows newest first', (tester) async {
    await pump(
      tester,
      seed: [
        NotificationsCompanion.insert(
          id: 'n1',
          sourceModule: 'reminders',
          sourceId: 'r1',
          title: 'Water plants',
          body: 'Reminder due now',
          createdAt: DateTime(2026, 1, 1),
          readAt: const Value(null),
        ),
        NotificationsCompanion.insert(
          id: 'n2',
          sourceModule: 'reminders',
          sourceId: 'r2',
          title: 'Pay rent',
          body: 'Reminder due now',
          createdAt: DateTime(2026, 1, 2),
          readAt: const Value(null),
        ),
      ],
    );

    expect(find.text('Water plants'), findsOneWidget);
    expect(find.text('Pay rent'), findsOneWidget);
    // Newest (Jan 2) renders above oldest (Jan 1).
    final payRentY = tester.getTopLeft(find.text('Pay rent')).dy;
    final waterPlantsY = tester.getTopLeft(find.text('Water plants')).dy;
    expect(payRentY, lessThan(waterPlantsY));
  });

  testWidgets(
    'tapping a reminder entry navigates to that reminder\'s detail screen',
    (tester) async {
      await pump(
        tester,
        seed: [
          NotificationsCompanion.insert(
            id: 'n1',
            sourceModule: 'reminders',
            sourceId: 'r1',
            title: 'Water plants',
            body: 'Reminder due now',
            createdAt: DateTime(2026, 1, 1),
            readAt: const Value(null),
          ),
        ],
      );

      await tester.tap(find.text('Water plants'));
      await tester.pumpAndSettle();

      expect(find.text('Reminder r1'), findsOneWidget);
    },
  );

  testWidgets(
    'an entry from a module with no detail destination is shown but not '
    'tappable',
    (tester) async {
      await pump(
        tester,
        seed: [
          NotificationsCompanion.insert(
            id: 'n1',
            sourceModule: 'habits',
            sourceId: 'h1',
            title: 'Habit archived',
            body: 'Cleanup',
            createdAt: DateTime(2026, 1, 1),
            readAt: const Value(null),
          ),
        ],
      );

      expect(find.text('Habit archived'), findsOneWidget);
      final tile = tester.widget<ListTile>(find.byType(ListTile));
      expect(tile.onTap, isNull);
    },
  );
}
