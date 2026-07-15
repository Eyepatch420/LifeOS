import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/features/home/presentation/widgets/timeline_stepper_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  const steps = [
    TimelineStep(
      icon: Icons.medication_outlined,
      label: 'Medicine',
      time: '2:00 PM',
      dotColor: Color(0xFF2F6FED),
    ),
    TimelineStep(
      icon: Icons.lunch_dining_outlined,
      label: 'Lunch',
      time: '12:30 PM',
      dotColor: Color(0xFFEF8A2C),
    ),
  ];

  testWidgets(
    'renders EmptyState with header still shown when steps is empty',
    (tester) async {
      await tester.pumpWidget(wrap(const TimelineStepperCard(steps: [])));

      expect(find.text("Today's Timeline"), findsOneWidget);
      expect(find.byType(EmptyState), findsOneWidget);
    },
  );

  testWidgets('renders one step widget per step when populated', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const TimelineStepperCard(steps: steps)));
    await tester.pump();

    expect(find.text('Medicine'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
  });

  testWidgets(
    'regression: stagger is applied per-step, not to the row as one unit',
    (tester) async {
      await tester.pumpWidget(wrap(const TimelineStepperCard(steps: steps)));

      // Immediately after the first frame, step 0 (no delay) should already
      // be further along its fade-in than step 1 (delayed by
      // Stagger.delayForIndex(1, ...)). If the stagger were still inert
      // (the old bug — the whole Row treated as one staggered child), both
      // steps would report identical opacity at this point.
      await tester.pump(const Duration(milliseconds: 40));

      final opacities = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .map((w) => w.opacity)
          .toList();

      expect(opacities.length, greaterThanOrEqualTo(2));
      expect(opacities[0], isNot(equals(opacities[1])));
    },
  );
}
