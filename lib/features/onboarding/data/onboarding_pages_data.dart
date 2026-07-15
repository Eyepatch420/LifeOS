import 'package:flutter/material.dart';
import 'package:lifeos/features/onboarding/domain/models/onboarding_accent.dart';
import 'package:lifeos/features/onboarding/domain/models/onboarding_page.dart';

/// Onboarding's 3 pillar accents — deliberately independent consts (not
/// imported from `kWorkspaceThemes`) per the project's decision to keep
/// onboarding's visual identity decoupled from workspace branding, even
/// though the hex values are drawn from the same Blue/Slate/Green families
/// as the Home/Documents/Health workspace palettes for visual consistency.
const _planningAccent = OnboardingAccent(
  primary: Color(0xFF2F6FED),
  gradient: [Color(0xFF1E4FBF), Color(0xFF5B9BF0)],
);

const _securityAccent = OnboardingAccent(
  primary: Color(0xFF5B6B7C),
  gradient: [Color(0xFF3F4B58), Color(0xFF71818F)],
);

const _wellnessAccent = OnboardingAccent(
  primary: Color(0xFF2FAE6A),
  gradient: [Color(0xFF1B8A4E), Color(0xFF57C387)],
);

/// The 3 onboarding pages, backed by real Lottie assets (see
/// assets/lottie/). `spare_presentation_activity.json` is intentionally
/// unused here — reserved for a potential 4th page or a future
/// analytics/activity screen (see docs/future_work.md).
const List<OnboardingPage> kOnboardingPages = [
  OnboardingPage(
    lottieAssetPath: 'assets/lottie/onboarding_planning.json',
    title: 'Plan your day, your way',
    subtitle:
        'Reminders, habits, and lists — all in one place, always on your device.',
    accent: _planningAccent,
  ),
  OnboardingPage(
    lottieAssetPath: 'assets/lottie/onboarding_security.json',
    title: 'Your data stays yours',
    subtitle:
        'No cloud, no accounts. Everything is encrypted and stored only on this phone.',
    accent: _securityAccent,
  ),
  OnboardingPage(
    lottieAssetPath: 'assets/lottie/onboarding_wellness.json',
    title: 'Feel better, one day at a time',
    subtitle:
        'Track your wellness and habits with a dashboard that keeps you motivated.',
    accent: _wellnessAccent,
  ),
];
