import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/onboarding/data/onboarding_pages_data.dart';
import 'package:lifeos/features/onboarding/domain/models/onboarding_accent.dart';
import 'package:lifeos/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:lifeos/features/onboarding/presentation/widgets/onboarding_illustration_morph.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/indicators/progress_dots.dart';

/// One fixed layout — illustration and text slots swap in place — rather
/// than a PageView, per the iOS-style onboarding polish called for in
/// docs/animation_spec.md.
///
/// Each page carries its own [OnboardingAccent] (Planning=Blue,
/// Security=Slate, Wellness=Green). The accent is animated between pages
/// via a single [TweenAnimationBuilder] driving an [OnboardingAccentTween]
/// (see `onboarding_accent.dart`), scoped entirely to this screen's
/// subtree — it never touches the app-wide `ThemeData`/`AnimatedTheme`
/// pipeline, which remains reserved for workspace/dark-mode theming (see
/// docs/theme.md).
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(onboardingPageIndexProvider);
    final notifier = ref.read(onboardingPageIndexProvider.notifier);
    final page = kOnboardingPages[pageIndex];
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return TweenAnimationBuilder<OnboardingAccent>(
      tween: OnboardingAccentTween(
        begin: kOnboardingPages.first.accent,
        end: page.accent,
      ),
      duration: AppMotionPresets.section.duration,
      curve: AppMotionPresets.section.curve,
      builder: (context, accent, child) {
        return Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  accent.gradient.first.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () => context.goNamed(RouteNames.userSetup),
                        child: const Text('Skip'),
                      ),
                    ),
                    const Spacer(),
                    OnboardingIllustrationMorph(
                      assetPath: page.lottieAssetPath,
                    ),
                    const SizedBox(height: 32),
                    _OnboardingTextSwitcher(
                      pageIndex: pageIndex,
                      title: page.title,
                      subtitle: page.subtitle,
                      reduceMotion: reduceMotion,
                    ),
                    const Spacer(),
                    ProgressDots(
                      count: kOnboardingPages.length,
                      activeIndex: pageIndex,
                      color: accent.primary,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: notifier.isLastPage ? 'Get Started' : 'Next',
                      color: accent.primary,
                      onPressed: () {
                        if (notifier.isLastPage) {
                          context.goNamed(RouteNames.userSetup);
                        } else {
                          notifier.next();
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Title/subtitle crossfade, independent of the illustration's transition —
/// fades and slides upward slightly rather than the default `AnimatedSwitcher`
/// fade-only behavior, per "fade + slide upward + crossfade independently."
class _OnboardingTextSwitcher extends StatelessWidget {
  const _OnboardingTextSwitcher({
    required this.pageIndex,
    required this.title,
    required this.subtitle,
    required this.reduceMotion,
  });

  final int pageIndex;
  final String title;
  final String subtitle;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotionPresets.section.duration,
      switchInCurve: AppMotionPresets.section.curve,
      switchOutCurve: AppMotionPresets.section.curve,
      transitionBuilder: (child, animation) {
        if (reduceMotion) {
          return FadeTransition(opacity: animation, child: child);
        }
        final slideTween = Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(slideTween),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey(pageIndex),
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
