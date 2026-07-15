import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/features/home/presentation/widgets/recent_notes_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets(
    'renders EmptyState with header still shown when notes is empty',
    (tester) async {
      await tester.pumpWidget(wrap(const RecentNotesCard(notes: [])));

      expect(find.text('Recent Notes'), findsOneWidget);
      expect(find.byType(EmptyState), findsOneWidget);
    },
  );

  testWidgets('renders one tile per note when populated', (tester) async {
    await tester.pumpWidget(
      wrap(
        const RecentNotesCard(
          notes: [
            NoteSummary(
              icon: Icons.list_alt_outlined,
              title: 'Grocery List',
              preview: 'Milk, Eggs',
              timestamp: 'Today',
              isPinned: true,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Grocery List'), findsOneWidget);
    expect(find.byType(EmptyState), findsNothing);
  });
}
