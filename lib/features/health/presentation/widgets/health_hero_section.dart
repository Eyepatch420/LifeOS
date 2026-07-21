import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_workspace_nav.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/shared/widgets/media/gradient_hero_background.dart';
import 'package:lifeos/theme/workspace_theme.dart';

/// Greeting + date + search/notification/avatar row + workspace nav,
/// composited over [GradientHeroBackground] — the Health analog of
/// `RemindersHeroSection`, structured identically (copy of the proven
/// pattern, not a reinvention — see that class's doc comment for why the
/// measured region must span the full interactive column through the
/// workspace nav, not just the top icon row, to avoid Reminders' historical
/// hit-testing bug).
class HealthHeroSection extends StatefulWidget {
  const HealthHeroSection({
    required this.greeting,
    required this.dateLabel,
    required this.userName,
    required this.theme,
    super.key,
    this.navItems,
    this.navSelectedIndex = 0,
    this.onSearchTap,
    this.onNotificationsTap,
    this.onAvatarTap,
    this.onControlsRegionMeasured,
  });

  final String greeting;
  final String dateLabel;
  final String userName;
  final WorkspaceTheme theme;
  final List<RemindersWorkspaceNavItem>? navItems;
  final int navSelectedIndex;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onAvatarTap;
  final HeroControlsRegionReporter? onControlsRegionMeasured;

  @override
  State<HealthHeroSection> createState() => _HealthHeroSectionState();
}

class _HealthHeroSectionState extends State<HealthHeroSection> {
  final GlobalKey _controlsRowKey = GlobalKey();

  @override
  void didUpdateWidget(covariant HealthHeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleMeasure();
  }

  @override
  void dispose() {
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
              overlayGradient: widget.theme.heroGradient,
              assetPath: 'assets/svg/health/green.svg',
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
                      Column(
                        key: _controlsRowKey,
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
                              _HeroIconButton(
                                icon: Icons.search,
                                semanticsLabel: 'Search',
                                onTap: widget.onSearchTap,
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
                              Flexible(
                                child: Text(
                                  widget.dateLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          RemindersWorkspaceNav(
                            theme: widget.theme,
                            items:
                                widget.navItems ??
                                RemindersWorkspaceNav.defaultItems,
                            selectedIndex: widget.navSelectedIndex,
                          ),
                        ],
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
