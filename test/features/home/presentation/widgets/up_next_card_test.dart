import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/features/home/presentation/widgets/up_next_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  const items = [
    UpNextItem(
      id: 'item-1',
      icon: Icons.medication_outlined,
      title: 'Metformin',
      subtitle: '2:00 PM',
      isUrgent: false,
    ),
    UpNextItem(
      id: 'item-2',
      icon: Icons.groups_outlined,
      title: 'Standup',
      subtitle: '10:30 AM',
      isUrgent: true,
    ),
  ];

  testWidgets(
    'renders EmptyState with header still shown when items is empty',
    (tester) async {
      await tester.pumpWidget(
        wrap(UpNextCard(items: const [], onDismiss: (_) {})),
      );

      expect(find.text('Up Next'), findsOneWidget);
      expect(find.byType(EmptyState), findsOneWidget);
    },
  );

  testWidgets('renders one tile per item when populated', (tester) async {
    await tester.pumpWidget(wrap(UpNextCard(items: items, onDismiss: (_) {})));

    expect(find.text('Metformin'), findsOneWidget);
    expect(find.text('Standup'), findsOneWidget);
    expect(find.byType(EmptyState), findsNothing);
  });

  testWidgets('swiping a tile invokes onDismiss with its id', (tester) async {
    String? dismissedId;
    await tester.pumpWidget(
      wrap(UpNextCard(items: items, onDismiss: (id) => dismissedId = id)),
    );

    await tester.drag(find.text('Metformin'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(dismissedId, 'item-1');
  });
}
