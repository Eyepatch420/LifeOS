import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/features/home/data/mock_dashboard_data.dart';
import 'package:lifeos/features/home/presentation/providers/home_providers.dart';
import 'package:lifeos/features/home/presentation/screens/timeline_detail_screen.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

void main() {
  testWidgets('renders the matching step by id', (tester) async {
    final step = kTimeline.first;
    await tester.pumpWidget(
      ProviderScope(
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
    await tester.pumpWidget(
      ProviderScope(
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
    final step = kTimeline.first;
    late ProviderContainer container;

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
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();

    // See new_note_screen_test.dart for why this listener is held open —
    // Riverpod 3.x defaults every provider to auto-dispose.
    final sub = container.listen(timelineProvider, (_, _) {});
    addTearDown(sub.close);

    router.push('/timeline/${step.id}');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Remove from Timeline'));
    await tester.pumpAndSettle();

    final remaining = container.read(timelineProvider).value;
    expect(remaining?.any((s) => s.id == step.id), isFalse);
  });
}
