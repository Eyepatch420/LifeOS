import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_dashboard_provider.dart';
import 'package:lifeos/features/home/presentation/providers/home_providers.dart';
import 'package:lifeos/features/home/presentation/screens/timeline_detail_screen.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

/// Timeline is now Agenda-backed (Phase 7) rather than mock-backed
/// (`kTimeline`) — seeds a real Calendar event via `eventsRepositoryProvider`
/// instead.
void main() {
  testWidgets('renders the matching step by id', (tester) async {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    await container
        .read(eventsRepositoryProvider)
        .create(
          id: 'e1',
          title: 'Standup',
          startAt: DateTime.now().add(const Duration(hours: 1)),
          isAllDay: false,
        );
    final sub = container.listen(timelineProvider, (_, _) {});
    addTearDown(sub.close);
    final steps = await container.read(timelineProvider.future);
    final step = steps.single;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: TimelineDetailScreen(stepId: step.id)),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text(step.label), findsOneWidget);
    expect(find.text(step.time), findsOneWidget);
    expect(find.text('Remove from Timeline'), findsOneWidget);
  });

  testWidgets('falls back to EmptyState for an unknown stepId', (tester) async {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: TimelineDetailScreen(stepId: 'not-a-real-step'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Remove from Timeline'), findsNothing);
  });

  testWidgets('Remove from Timeline dismisses the step and pops', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    await container
        .read(eventsRepositoryProvider)
        .create(
          id: 'e1',
          title: 'Standup',
          startAt: DateTime.now().add(const Duration(hours: 1)),
          isAllDay: false,
        );
    final sub = container.listen(timelineProvider, (_, _) {});
    addTearDown(sub.close);
    final steps = await container.read(timelineProvider.future);
    final step = steps.single;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/timeline/:stepId',
          builder: (context, state) =>
              TimelineDetailScreen(stepId: state.pathParameters['stepId']!),
        ),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    router.push('/timeline/${step.id}');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Remove from Timeline'));
    await tester.pumpAndSettle();

    final remaining = container.read(timelineProvider).value;
    expect(remaining?.any((s) => s.id == step.id), isFalse);
  });
}
