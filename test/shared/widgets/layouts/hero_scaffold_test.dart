import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';

void main() {
  const heroKey = Key('hero');
  const contentKey = Key('content');

  Widget wrap({double heroOverlap = 24}) {
    return MaterialApp(
      home: Scaffold(
        body: HeroScaffold(
          heroOverlap: heroOverlap,
          hero: Container(key: heroKey, height: 320, color: Colors.blue),
          content: Column(
            key: contentKey,
            children: [
              for (var i = 0; i < 12; i++)
                const SizedBox(height: 100, width: double.infinity),
            ],
          ),
        ),
      ),
    );
  }

  Opacity heroOpacity(WidgetTester tester) => tester.widget<Opacity>(
    find.ancestor(of: find.byKey(heroKey), matching: find.byType(Opacity)),
  );

  ScrollController controllerOf(WidgetTester tester) => tester
      .widget<CustomScrollView>(find.byType(CustomScrollView))
      .controller!;

  testWidgets('lays out without overflow and hero starts fully visible', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(heroOpacity(tester).opacity, 1.0);
  });

  testWidgets('sheet initially starts at heroHeight - heroOverlap', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    final width = tester.getSize(find.byType(HeroScaffold)).width;
    final expectedSheetTop = HeroScaffold.heroHeightFor(width) - 24;

    // The content sits inside the sheet, which pads its own top by 24.
    final contentTop = tester.getTopLeft(find.byKey(contentKey)).dy;
    expect(contentTop, expectedSheetTop + 24);
  });

  testWidgets('hero stays fully visible while offset is within the overlap', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    controllerOf(tester).jumpTo(20);
    await tester.pump();

    expect(heroOpacity(tester).opacity, 1.0);
  });

  testWidgets('hero fades progressively once past the overlap', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    final controller = controllerOf(tester);
    final width = tester.getSize(find.byType(HeroScaffold)).width;
    final sheetTop = HeroScaffold.heroHeightFor(width) - 24;

    controller.jumpTo(sheetTop / 2);
    await tester.pump();
    final midOpacity = heroOpacity(tester).opacity;
    expect(midOpacity, lessThan(1.0));
    expect(midOpacity, greaterThan(0.0));

    // Sheet has reached the top of the screen: hero fully gone.
    controller.jumpTo(sheetTop);
    await tester.pump();
    expect(heroOpacity(tester).opacity, 0.0);
  });

  testWidgets('sheet covers the hero once fully scrolled', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    final controller = controllerOf(tester);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    expect(heroOpacity(tester).opacity, 0.0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('short content still fills the viewport with the sheet', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HeroScaffold(
            hero: SizedBox(key: heroKey, height: 320),
            content: SizedBox(key: contentKey, height: 50),
          ),
        ),
      ),
    );
    await tester.pump();

    final controller = controllerOf(tester);
    // Enough scroll range for the sheet to fully cover the hero.
    final width = tester.getSize(find.byType(HeroScaffold)).width;
    final sheetTop = HeroScaffold.heroHeightFor(width) - 24;
    expect(controller.position.maxScrollExtent, greaterThanOrEqualTo(sheetTop));
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not overflow on a very small screen', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
