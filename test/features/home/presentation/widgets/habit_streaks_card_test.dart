import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/features/home/presentation/widgets/habit_streaks_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets(
    'renders EmptyState with header still shown when streaks is empty',
    (tester) async {
      await tester.pumpWidget(wrap(const HabitStreaksCard(streaks: [])));

      expect(find.text('Habit Streaks'), findsOneWidget);
      expect(find.byType(EmptyState), findsOneWidget);
    },
  );

  testWidgets('renders one tile per streak when populated', (tester) async {
    await tester.pumpWidget(
      wrap(
        const HabitStreaksCard(
          streaks: [
            HabitStreak(
              icon: Icons.directions_walk,
              title: 'Morning Walk',
              streakDays: 12,
              last7Days: [true, true, false],
            ),
          ],
        ),
      ),
    );

    expect(find.text('Morning Walk'), findsOneWidget);
    expect(find.byType(EmptyState), findsNothing);
  });
}
