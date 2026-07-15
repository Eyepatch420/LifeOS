import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';

void main() {
  testWidgets('renders at the default height', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SectionLoadingPlaceholder())),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(sizedBox.height, 120);
  });

  testWidgets('renders at a custom height', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SectionLoadingPlaceholder(height: 80)),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(sizedBox.height, 80);
  });
}
