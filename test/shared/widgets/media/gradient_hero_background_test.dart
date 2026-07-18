import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/shared/widgets/media/gradient_hero_background.dart';

void main() {
  const morningGradient = [Color(0xFF2F6FED), Color(0xFF5B9BF0)];
  const eveningGradient = [Color(0xFF7A5CC9), Color(0xFF4F3B8F)];

  testWidgets('renders with the default assetPath when unspecified', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GradientHeroBackground(
            height: 240,
            overlayGradient: morningGradient,
            overlayKey: 'morning',
          ),
        ),
      ),
    );

    final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
      (picture.bytesLoader as SvgAssetLoader).assetName,
      'assets/svg/home/home_hero_background.svg',
    );
  });

  testWidgets('renders with a custom assetPath when supplied', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GradientHeroBackground(
            height: 240,
            overlayGradient: morningGradient,
            overlayKey: 'morning',
            assetPath: 'assets/svg/health/custom_hero.svg',
          ),
        ),
      ),
    );

    final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
      (picture.bytesLoader as SvgAssetLoader).assetName,
      'assets/svg/health/custom_hero.svg',
    );
  });

  testWidgets('overlay gradient change does not throw', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GradientHeroBackground(
            height: 240,
            overlayGradient: morningGradient,
            overlayKey: 'morning',
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GradientHeroBackground(
            height: 240,
            overlayGradient: eveningGradient,
            overlayKey: 'evening',
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    expect(tester.takeException(), isNull);
  });

  testWidgets('renders correctly with no overlayKey supplied (static '
      'gradient that never changes for the widget\'s lifetime)', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GradientHeroBackground(
            height: 240,
            overlayGradient: morningGradient,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
