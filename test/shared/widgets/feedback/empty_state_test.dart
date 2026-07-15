import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders icon and message', (tester) async {
    await tester.pumpWidget(
      wrap(
        const EmptyState(icon: Icons.inbox_outlined, message: 'Nothing here'),
      ),
    );

    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('renders CTA only when both ctaLabel and onCtaTap are supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const EmptyState(
          icon: Icons.inbox_outlined,
          message: 'Nothing here',
          ctaLabel: 'Add one',
        ),
      ),
    );

    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('CTA tap invokes the callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        EmptyState(
          icon: Icons.inbox_outlined,
          message: 'Nothing here',
          ctaLabel: 'Add one',
          onCtaTap: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(TextButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('renders without throwing under Reduce Motion', (tester) async {
    await tester.pumpWidget(
      wrap(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: EmptyState(
            icon: Icons.inbox_outlined,
            message: 'Nothing here',
          ),
        ),
      ),
    );

    expect(find.text('Nothing here'), findsOneWidget);
  });
}
