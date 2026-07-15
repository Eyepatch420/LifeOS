import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the label when not loading', (tester) async {
    await tester.pumpWidget(
      wrap(PrimaryButton(label: 'Continue', onPressed: () {})),
    );

    expect(find.text('Continue'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows a loading indicator instead of the label when isLoading', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(PrimaryButton(label: 'Continue', onPressed: () {}, isLoading: true)),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
  });

  testWidgets('disabled (onPressed null) does not invoke a tap', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(PrimaryButton(label: 'Continue', onPressed: null)),
    );

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(tapped, isFalse);
  });

  testWidgets('applies the color override to the FilledButton background', (
    tester,
  ) async {
    const overrideColor = Colors.deepPurple;
    await tester.pumpWidget(
      wrap(
        PrimaryButton(
          label: 'Continue',
          onPressed: () {},
          color: overrideColor,
        ),
      ),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    final resolvedBackground = button.style?.backgroundColor?.resolve({});
    expect(resolvedBackground, overrideColor);
  });

  testWidgets('tapping an enabled button invokes onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(PrimaryButton(label: 'Continue', onPressed: () => tapped = true)),
    );

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
