import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/features/user_setup/presentation/widgets/avatar_picker_grid.dart';
import 'package:lifeos/features/user_setup/presentation/widgets/theme_mode_selector.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';
import 'package:lifeos/theme/theme_providers.dart';

/// Profile + app settings, pushed from the Home hero's avatar. Shows the
/// user's name/avatar (read-only here — editing them is onboarding's job)
/// and the one setting that needs to live somewhere reachable post-setup:
/// light/dark/system theme, via the same [ThemeModeSelector] onboarding
/// uses, now writing through `userProfileNotifierProvider`'s
/// `updateThemeMode` so the change is both live and persisted.
class ProfilePlaceholderScreen extends ConsumerWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);

    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Profile'),
      content: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Could not load profile',
            style: context.textTheme.bodyMedium,
          ),
        ),
        data: (profile) => FadeSlideIn(
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    _ProfileAvatar(avatarId: profile?.avatarAssetPath),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      profile?.name.isNotEmpty == true
                          ? profile!.name
                          : 'there',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Appearance', style: context.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              ThemeModeSelector(
                value: themeMode,
                onChanged: (mode) {
                  ref
                      .read(userProfileNotifierProvider.notifier)
                      .updateThemeMode(mode);
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.avatarId});

  final String? avatarId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colorScheme.primary.withValues(alpha: 0.16),
      ),
      child: Icon(
        avatarIconFor(avatarId),
        size: 40,
        color: context.colorScheme.primary,
      ),
    );
  }
}
