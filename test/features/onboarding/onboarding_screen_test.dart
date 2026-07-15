import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/onboarding/data/onboarding_pages_data.dart';
import 'package:lifeos/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/indicators/progress_dots.dart';

void main() {
  Future<void> pumpOnboarding(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: RoutePaths.onboarding,
            routes: [
              GoRoute(
                path: RoutePaths.onboarding,
                builder: (context, state) => const OnboardingScreen(),
              ),
              GoRoute(
                path: RoutePaths.userSetup,
                builder: (context, state) =>
                    const Scaffold(body: Text('Setup')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('renders page 1 title and Next label', (tester) async {
    await pumpOnboarding(tester);
    await tester.pump();

    expect(find.text(kOnboardingPages[0].title), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets(
    'PrimaryButton color matches page 1 accent, then updates after Next',
    (tester) async {
      await pumpOnboarding(tester);
      await tester.pump();

      PrimaryButton readButton() =>
          tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      ProgressDots readDots() =>
          tester.widget<ProgressDots>(find.byType(ProgressDots));

      expect(readButton().color, kOnboardingPages[0].accent.primary);
      expect(readDots().color, kOnboardingPages[0].accent.primary);

      await tester.tap(find.text('Next'));
      // Bounded pumps rather than pumpAndSettle: LottieIllustration's looping
      // animation never reaches a quiescent frame, so pumpAndSettle would
      // time out waiting for it. Advance past the accent tween's own duration
      // instead (see AppMotionPresets.section).
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(readButton().color, kOnboardingPages[1].accent.primary);
      expect(readDots().color, kOnboardingPages[1].accent.primary);
      expect(find.text(kOnboardingPages[1].title), findsOneWidget);
    },
  );

  testWidgets('shows Get Started on the last page', (tester) async {
    await pumpOnboarding(tester);
    await tester.pump();

    for (var i = 0; i < kOnboardingPages.length - 1; i++) {
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    expect(find.text('Get Started'), findsOneWidget);
  });
}
