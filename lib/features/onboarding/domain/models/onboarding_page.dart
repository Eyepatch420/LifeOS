import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/onboarding/domain/models/onboarding_accent.dart';

part 'onboarding_page.freezed.dart';

/// One page of content in the onboarding flow — the illustration and
/// text slots are swapped in place inside a single fixed layout (see
/// `OnboardingScreen`), not a PageView.
@freezed
abstract class OnboardingPage with _$OnboardingPage {
  const factory OnboardingPage({
    required String lottieAssetPath,
    required String title,
    required String subtitle,
    required OnboardingAccent accent,
  }) = _OnboardingPage;
}
