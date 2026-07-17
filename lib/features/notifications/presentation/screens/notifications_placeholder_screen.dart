import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// "Coming soon" stub pushed from the Home hero's notification icon — see
/// `PlaceholderScaffold` for the equivalent shell-tab-root pattern; this is
/// its pushed-screen counterpart, built on [PushedScreenLayout] since it
/// rides the root navigator, not a shell branch.
class NotificationsPlaceholderScreen extends StatelessWidget {
  const NotificationsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Notifications'),
      content: Center(
        child: FadeSlideIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 56,
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Coming soon', style: context.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
