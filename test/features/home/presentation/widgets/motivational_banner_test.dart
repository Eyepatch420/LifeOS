import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/home/presentation/widgets/motivational_banner.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the message', (tester) async {
    await tester.pumpWidget(
      wrap(const MotivationalBanner(message: 'Keep going.')),
    );

    expect(find.text('Keep going.'), findsOneWidget);
  });

  testWidgets(
    'neither onTap nor onDismiss supplied renders a plain, non-interactive banner',
    (tester) async {
      await tester.pumpWidget(
        wrap(const MotivationalBanner(message: 'Keep going.')),
      );

      expect(find.byType(GestureDetector), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    },
  );

  testWidgets('onTap makes the banner tappable and shows the chevron', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        MotivationalBanner(message: 'Keep going.', onTap: () => tapped = true),
      ),
    );

    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.byType(MotivationalBanner));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets(
    'onDismiss shows a close icon and invokes the callback, no chevron',
    (tester) async {
      var dismissed = false;
      await tester.pumpWidget(
        wrap(
          MotivationalBanner(
            message: 'Keep going.',
            onDismiss: () => dismissed = true,
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(dismissed, isTrue);
    },
  );
}
