import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/home/presentation/widgets/motivational_banner.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/shared/widgets/media/gradient_hero_background.dart';
import 'package:lifeos/theme/time_of_day_theme.dart';

/// Greeting + date + search/notification/avatar row + motivational banner,
/// composited over [GradientHeroBackground]. Height is a responsive
/// fraction of screen width so the tablet-landscape SVG art crops sensibly
/// via `cover` on any phone size (see docs/theme.md).
///
/// Purely presentational — `HomeScreen` reads `clockTickProvider`/
/// `userProfileNotifierProvider` and passes the resolved greeting/date/name
/// down as props, matching every other Home section widget's "props in, no
/// provider reads" pattern.
class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    required this.greeting,
    required this.dateLabel,
    required this.userName,
    required this.tint,
    required this.motivationalMessage,
    super.key,
    this.onSearchTap,
    this.onNotificationsTap,
    this.onAvatarTap,
    this.onBannerTap,
  });

  final String greeting;
  final String dateLabel;
  final String userName;
  final TimeOfDayTint tint;
  final String motivationalMessage;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onBannerTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final heroHeight = HeroScaffold.heroHeightFor(constraints.maxWidth);
        return Stack(
          children: [
            GradientHeroBackground(height: heroHeight, tint: tint),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.xl,
                  0,
                ),
                child: FadeSlideIn(
                  duration: AppMotionPresets.hero.duration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$greeting,',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  userName.isNotEmpty ? userName : 'there',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _HeroIconButton(
                            icon: Icons.search,
                            semanticsLabel: 'Search',
                            onTap: onSearchTap,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _HeroIconButton(
                            icon: Icons.notifications_outlined,
                            semanticsLabel: 'Notifications',
                            onTap: onNotificationsTap,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _HeroAvatar(onTap: onAvatarTap),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            dateLabel,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      MotivationalBanner(
                        message: motivationalMessage,
                        onTap: onBannerTap,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  const _HeroIconButton({
    required this.icon,
    required this.semanticsLabel,
    this.onTap,
  });

  final IconData icon;
  final String semanticsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: Material(
        color: Colors.white.withValues(alpha: 0.18),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap ?? () {},
          child: SizedBox(
            width: AppSpacing.heroIconButtonSize,
            height: AppSpacing.heroIconButtonSize,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _HeroAvatar extends StatelessWidget {
  const _HeroAvatar({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Profile',
      child: GestureDetector(
        onTap: onTap,
        child: const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white),
        ),
      ),
    );
  }
}
