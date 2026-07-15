import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';

void main() {
  Widget wrap(Widget child, {double width = 320}) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(width: width, child: child),
      ),
    );
  }

  testWidgets('renders title and View all when onViewAll is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(SectionHeader(title: 'Up Next', onViewAll: () {})),
    );

    expect(find.text('Up Next'), findsOneWidget);
    expect(find.text('View all'), findsOneWidget);
  });

  testWidgets('omits View all when onViewAll is null', (tester) async {
    await tester.pumpWidget(wrap(const SectionHeader(title: 'Up Next')));

    expect(find.text('View all'), findsNothing);
  });

  testWidgets(
    'regression: a long title does not overflow the Row, even on a narrow '
    'card (was: unbounded Text with no Expanded/ellipsis)',
    (tester) async {
      await tester.pumpWidget(
        wrap(
          const SectionHeader(title: "Today's Timeline And Upcoming Events"),
          width: 280,
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('regression: a long title alongside View all does not overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        SectionHeader(
          title: "Today's Timeline And Upcoming Events",
          onViewAll: () {},
        ),
        width: 280,
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('View all'), findsOneWidget);
  });
}
