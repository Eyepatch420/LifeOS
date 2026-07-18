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
          heroBuilder: (context, reportControlsRegion) =>
              Container(key: heroKey, height: 320, color: Colors.blue),
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
      MaterialApp(
        home: Scaffold(
          body: HeroScaffold(
            heroBuilder: (context, reportControlsRegion) =>
                const SizedBox(key: heroKey, height: 320),
            content: const SizedBox(key: contentKey, height: 50),
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

  group('hit-test exclusion for a reported controls region', () {
    final buttonKey = GlobalKey();

    Widget wrapWithButton() {
      return MaterialApp(
        home: Scaffold(
          body: HeroScaffold(
            heroBuilder: (context, reportControlsRegion) => _MeasuredHero(
              buttonKey: buttonKey,
              onReport: reportControlsRegion,
              onButtonTap: () {},
            ),
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

    testWidgets(
      'at initial offset, tapping the reported region reaches the real '
      'button underneath instead of the scroll view',
      (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HeroScaffold(
                heroBuilder: (context, reportControlsRegion) => _MeasuredHero(
                  buttonKey: buttonKey,
                  onReport: reportControlsRegion,
                  onButtonTap: () => tapped = true,
                ),
                content: const SizedBox(height: 2000),
              ),
            ),
          ),
        );
        // Let the post-frame measurement callback run and rebuild with the
        // reported rect applied.
        await tester.pump();
        await tester.pump();

        await tester.tap(find.byKey(buttonKey));
        await tester.pump();

        expect(tapped, isTrue);
      },
    );

    testWidgets(
      'dragging from outside the reported region still scrolls the sheet',
      (tester) async {
        await tester.pumpWidget(wrapWithButton());
        await tester.pump();
        await tester.pump();

        final controller = controllerOf(tester);
        expect(controller.offset, 0.0);

        // Drag from a point well below the (small, top-corner) button
        // region, inside the hero but not inside the exclusion rect —
        // using an explicit on-screen point rather than the (off-screen,
        // far taller than the viewport) content Column's own center.
        await tester.dragFrom(const Offset(400, 200), const Offset(0, -100));
        await tester.pump();

        expect(controller.offset, greaterThan(0.0));
      },
    );

    testWidgets(
      'once scrolled past the hero interaction threshold, the exclusion is '
      'removed and the scroll view handles the whole region normally',
      (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HeroScaffold(
                heroBuilder: (context, reportControlsRegion) => _MeasuredHero(
                  buttonKey: buttonKey,
                  onReport: reportControlsRegion,
                  onButtonTap: () => tapped = true,
                ),
                content: const SizedBox(height: 2000),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump();

        final controller = controllerOf(tester);
        final width = tester.getSize(find.byType(HeroScaffold)).width;
        final sheetTop = HeroScaffold.heroHeightFor(width) - 24;

        controller.jumpTo(sheetTop);
        await tester.pump();
        await tester.pump();

        // The button's Positioned/Opacity ancestor now ignores pointers
        // (hero opacity is 0), so even though the scroll view no longer
        // excludes that rect, the tap has nothing left to hit there except
        // the (now non-interactive) hero — confirming the sheet, not a
        // stale exclusion hole, owns that region.
        await tester.tapAt(tester.getCenter(find.byKey(buttonKey)));
        await tester.pump();

        expect(tapped, isFalse);
      },
    );
  });
}

/// Test-only hero: measures [buttonKey]'s bounds and reports them via
/// [onReport], mirroring what `HomeHeroSection` does for its real button
/// row — used to exercise `HeroScaffold`'s hit-test exclusion without
/// depending on the Home feature.
class _MeasuredHero extends StatefulWidget {
  const _MeasuredHero({
    required this.buttonKey,
    required this.onReport,
    required this.onButtonTap,
  });

  final GlobalKey buttonKey;
  final void Function(Rect?) onReport;
  final VoidCallback onButtonTap;

  @override
  State<_MeasuredHero> createState() => _MeasuredHeroState();
}

class _MeasuredHeroState extends State<_MeasuredHero> {
  void _scheduleMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = widget.buttonKey.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) {
        widget.onReport(null);
        return;
      }
      widget.onReport(box.localToGlobal(Offset.zero) & box.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    _scheduleMeasure();
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          key: widget.buttonKey,
          width: 44,
          height: 44,
          child: Material(
            color: Colors.blue,
            child: InkWell(onTap: widget.onButtonTap),
          ),
        ),
      ),
    );
  }
}
