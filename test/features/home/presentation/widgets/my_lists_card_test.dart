import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/features/home/presentation/widgets/my_lists_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets(
    'renders EmptyState with header still shown when lists is empty',
    (tester) async {
      await tester.pumpWidget(wrap(const MyListsCard(lists: [])));

      expect(find.text('My Lists'), findsOneWidget);
      expect(find.byType(EmptyState), findsOneWidget);
    },
  );

  testWidgets('renders one tile per list when populated', (tester) async {
    await tester.pumpWidget(
      wrap(
        const MyListsCard(
          lists: [
            ListSummary(
              icon: Icons.shopping_basket_outlined,
              title: 'Shopping',
              subtitle: '5 items left',
              progress: 0.6,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Shopping'), findsOneWidget);
    expect(find.byType(EmptyState), findsNothing);
  });
}
