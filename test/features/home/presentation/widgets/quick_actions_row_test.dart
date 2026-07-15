import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/features/home/presentation/widgets/quick_actions_row.dart';
import 'package:lifeos/shared/widgets/buttons/circular_action_button.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  const actions = [
    QuickAction(
      id: 'new_note',
      icon: Icons.note_add_outlined,
      label: 'New Note',
    ),
    QuickAction(
      id: 'new_reminder',
      icon: Icons.notifications_outlined,
      label: 'New Reminder',
    ),
  ];

  testWidgets('renders EmptyState when actions is empty', (tester) async {
    await tester.pumpWidget(
      wrap(
        QuickActionsRow(
          actions: const [],
          onActionTap: const {},
          onViewAll: () {},
        ),
      ),
    );

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(CircularActionButton), findsNothing);
  });

  testWidgets('renders one CircularActionButton per action', (tester) async {
    await tester.pumpWidget(
      wrap(
        QuickActionsRow(
          actions: actions,
          onActionTap: const {},
          onViewAll: () {},
        ),
      ),
    );

    expect(find.byType(CircularActionButton), findsNWidgets(2));
    expect(find.text('New Note'), findsOneWidget);
    expect(find.text('New Reminder'), findsOneWidget);
  });

  testWidgets('tapping an action with a registered id invokes its callback', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        QuickActionsRow(
          actions: actions,
          onActionTap: {'new_note': () => tapped = true},
          onViewAll: () {},
        ),
      ),
    );

    await tester.tap(find.text('New Note'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('tapping an action with an unregistered id is a safe no-op', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        QuickActionsRow(
          actions: actions,
          onActionTap: const {},
          onViewAll: () {},
        ),
      ),
    );

    await tester.tap(find.text('New Reminder'));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
