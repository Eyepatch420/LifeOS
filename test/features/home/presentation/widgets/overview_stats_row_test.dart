import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/home/data/mock_dashboard_data.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/features/home/presentation/widgets/overview_stats_row.dart';
import 'package:lifeos/shared/widgets/cards/stat_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

void main() {
  const stats = [
    OverviewStat(
      icon: Icons.checklist_rounded,
      label: 'Tasks',
      value: '4',
      subtitle: '2 done',
      progress: 0.5,
    ),
  ];

  Widget wrap(Widget child, {Size size = const Size(400, 800)}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('renders EmptyState when stats is empty, at phone width', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const OverviewStatsRow(stats: [])));

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(StatCard), findsNothing);
  });

  testWidgets(
    'regression: empty stats at tablet width does not throw (columns=0 crash)',
    (tester) async {
      // Tablet-width viewport is exactly the scenario that previously threw
      // an assertion error (crossAxisCount computed as stats.length == 0).
      await tester.pumpWidget(
        wrap(const OverviewStatsRow(stats: []), size: const Size(900, 800)),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(EmptyState), findsOneWidget);
    },
  );

  testWidgets('renders a StatCard per stat at phone width', (tester) async {
    await tester.pumpWidget(wrap(const OverviewStatsRow(stats: stats)));

    expect(find.byType(StatCard), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
  });

  testWidgets('renders a StatCard per stat at tablet width', (tester) async {
    await tester.pumpWidget(
      wrap(const OverviewStatsRow(stats: stats), size: const Size(900, 800)),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(StatCard), findsOneWidget);
  });

  testWidgets(
    'regression: real stat data does not overflow a StatCard cell on a '
    'small phone at larger text scales (was: fixed childAspectRatio grid '
    'clipping a taller Column)',
    (tester) async {
      for (final scale in [1.0, 1.3, 1.5, 2.0]) {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: const Size(320, 800),
                textScaler: TextScaler.linear(scale),
              ),
              child: const Scaffold(
                body: OverviewStatsRow(stats: kOverviewStats),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          tester.takeException(),
          isNull,
          reason: 'Overflow at textScale=$scale',
        );
      }
    },
  );
}
