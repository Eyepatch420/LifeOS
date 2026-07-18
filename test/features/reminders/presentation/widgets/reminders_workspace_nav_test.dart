import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_workspace_nav.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

void main() {
  final theme = kWorkspaceThemes[WorkspaceIds.reminders]!;

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders all default items with Reminders active by default', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(RemindersWorkspaceNav(theme: theme)));
    await tester.pump();

    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('Planner'), findsOneWidget);
    expect(find.text('Habits'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
  });

  testWidgets('invokes onSelected for an item when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        RemindersWorkspaceNav(
          theme: theme,
          items: [
            RemindersWorkspaceNavItem(
              label: 'Reminders',
              icon: Icons.notifications_outlined,
              onSelected: () => tapped = true,
            ),
            const RemindersWorkspaceNavItem(
              label: 'Planner',
              icon: Icons.calendar_month_outlined,
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Reminders'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('an item with no onSelected does not throw when tapped', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(RemindersWorkspaceNav(theme: theme)));
    await tester.pump();

    await tester.tap(find.text('Planner'));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
