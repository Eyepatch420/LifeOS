import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';

/// Shared structural shell for every screen pushed on top of a tab (as
/// opposed to [FloatingPageLayout]/[HeroScaffold], which are for shell tab
/// roots): `Scaffold` → `SafeArea` (both edges) → [header] → `Expanded`
/// [content] → optional bottom [ctaButton].
///
/// Pushed screens ride the root navigator (see `app_router.dart`'s
/// `parentNavigatorKey` routes under `/home`), so [FloatingBottomNav] isn't
/// in their tree and `FloatingPageLayout.navClearance` padding would be
/// dead weight — this layout has none of that, just the header/content/CTA
/// structure every pushed screen in this module shares.
class PushedScreenLayout extends StatelessWidget {
  const PushedScreenLayout({
    required this.header,
    required this.content,
    super.key,
    this.ctaButton,
  });

  final Widget header;
  final Widget content;

  /// Primary action (e.g. "Save Note", "Remove from Timeline"). Omitted for
  /// screens with no single primary action (Search, placeholder stubs).
  final Widget? ctaButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              const SizedBox(height: AppSpacing.lg),
              Expanded(child: content),
              if (ctaButton != null) ...[
                const SizedBox(height: AppSpacing.lg),
                ctaButton!,
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
