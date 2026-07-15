import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/extensions/datetime_extensions.dart';
import 'package:lifeos/shared/widgets/media/gradient_hero_background.dart';
import 'package:lifeos/theme/time_of_day_theme.dart';

void main() {
  const morning = TimeOfDayTint(
    gradient: [Color(0xFF2F6FED), Color(0xFF5B9BF0)],
    greeting: 'Good morning',
    bucket: TimeOfDayBucket.morning,
  );
  const evening = TimeOfDayTint(
    gradient: [Color(0xFF7A5CC9), Color(0xFF4F3B8F)],
    greeting: 'Good evening',
    bucket: TimeOfDayBucket.evening,
  );

  testWidgets('renders with the default assetPath when unspecified', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GradientHeroBackground(height: 240, tint: morning),
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
            tint: morning,
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

  testWidgets('tint change does not throw', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GradientHeroBackground(height: 240, tint: morning),
        ),
      ),
    );
    await tester.pump();

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GradientHeroBackground(height: 240, tint: evening),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    expect(tester.takeException(), isNull);
  });
}
