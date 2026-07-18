import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/home/presentation/providers/home_providers.dart';
import 'package:lifeos/features/home/presentation/providers/home_section_registry.dart';
import 'package:lifeos/features/home/presentation/widgets/home_hero_section.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/shared/widgets/layouts/floating_page_layout.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/theme/time_of_day_theme.dart';

/// Renders the Home Workspace by rendering `dashboardSections(ref)` (order +
/// visibility + builder, already joined) — reordering/hiding a section
/// later is a provider write, never a change to this screen (see
/// docs/architecture.md and docs/architecture_principles.md).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockTickProvider).value ?? DateTime.now();
    final tint = timeOfDayTintFor(now);
    final profile = ref.watch(userProfileNotifierProvider).value;
    final motivationalMessage = ref.watch(motivationalMessageProvider);

    final sections = dashboardSections(ref);

    return FloatingPageLayout(
      body: HeroScaffold(
        heroBuilder: (context, reportControlsRegion) => HomeHeroSection(
          greeting: tint.greeting,
          dateLabel: DateFormat('EEEE, d MMMM yyyy').format(now),
          userName: profile?.name ?? '',
          tint: tint,
          motivationalMessage: motivationalMessage,
          onSearchTap: () => context.pushNamed(RouteNames.search),
          onNotificationsTap: () => context.pushNamed(RouteNames.notifications),
          onAvatarTap: () => context.pushNamed(RouteNames.profile),
          onControlsRegionMeasured: reportControlsRegion,
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            FloatingPageLayout.navClearance,
          ),
          child: StaggeredEntrance(
            children: [
              for (final section in sections.where((s) => s.meta.visible))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  child: section.builder(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
