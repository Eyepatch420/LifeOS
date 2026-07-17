import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// "Coming soon" stub pushed from the Home hero's avatar. Lives under
/// `user_setup/` since profile data is `UserProfile`/
/// `user_profile_providers.dart`'s domain, not a new feature area.
class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Profile'),
      content: Center(
        child: FadeSlideIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_outline,
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
