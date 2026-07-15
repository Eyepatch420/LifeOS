import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/onboarding/data/onboarding_pages_data.dart';

/// Current page in the onboarding single-layout crossfade (0–2). Bounded so
/// `next()`/`previous()` never step outside `kOnboardingPages`.
class OnboardingPageIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  bool get isLastPage => state == kOnboardingPages.length - 1;

  void next() {
    if (state < kOnboardingPages.length - 1) state += 1;
  }

  void previous() {
    if (state > 0) state -= 1;
  }
}

final onboardingPageIndexProvider =
    NotifierProvider<OnboardingPageIndexNotifier, int>(
      OnboardingPageIndexNotifier.new,
    );
