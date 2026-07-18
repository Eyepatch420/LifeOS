import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/home/presentation/widgets/motivational_banner.dart';
import 'package:lifeos/features/search/domain/search_hero_tags.dart';
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
///
/// Measures the search/notification/avatar row's on-screen bounds after
/// every layout and reports them via [onControlsRegionMeasured] (in global
/// coordinates — see [HeroControlsRegionReporter]) so `HeroScaffold` can
/// keep its scroll view from swallowing taps meant for these buttons. This
/// widget has no idea `HeroScaffold` exists beyond that callback's shape.
class HomeHeroSection extends StatefulWidget {
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
    this.onControlsRegionMeasured,
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
  final HeroControlsRegionReporter? onControlsRegionMeasured;

  @override
  State<HomeHeroSection> createState() => _HomeHeroSectionState();
}

class _HomeHeroSectionState extends State<HomeHeroSection> {
  final GlobalKey _controlsRowKey = GlobalKey();

  @override
  void didUpdateWidget(covariant HomeHeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleMeasure();
  }

  @override
  void dispose() {
    // Nothing further to report once this widget is gone.
    widget.onControlsRegionMeasured?.call(null);
    super.dispose();
  }

  void _scheduleMeasure() {
    final reporter = widget.onControlsRegionMeasured;
    if (reporter == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = _controlsRowKey.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) {
        reporter(null);
        return;
      }
      reporter(box.localToGlobal(Offset.zero) & box.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    _scheduleMeasure();
    return LayoutBuilder(
      builder: (context, constraints) {
        final heroHeight = HeroScaffold.heroHeightFor(constraints.maxWidth);
        return Stack(
          children: [
            GradientHeroBackground(
              height: heroHeight,
              overlayGradient: widget.tint.gradient,
              overlayKey: widget.tint.bucket,
            ),
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        key: _controlsRowKey,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.greeting},',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  widget.userName.isNotEmpty
                                      ? widget.userName
                                      : 'there',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Hero(
                            tag: searchMorphHeroTag,
                            child: _HeroIconButton(
                              icon: Icons.search,
                              semanticsLabel: 'Search',
                              onTap: widget.onSearchTap,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _HeroIconButton(
                            icon: Icons.notifications_outlined,
                            semanticsLabel: 'Notifications',
                            onTap: widget.onNotificationsTap,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _HeroAvatar(onTap: widget.onAvatarTap),
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
                            widget.dateLabel,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      MotivationalBanner(
                        message: widget.motivationalMessage,
                        onTap: widget.onBannerTap,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
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
