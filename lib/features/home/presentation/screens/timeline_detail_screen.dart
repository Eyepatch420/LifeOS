import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/home/presentation/providers/home_providers.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// Minimal detail screen for one Timeline step, pushed via
/// `timeline/:stepId`. Looks up the step by [stepId] from `timelineProvider`
/// each build — falls back to an [EmptyState] if the step was already
/// dismissed elsewhere (a legitimate case: a stale deep link, or the user
/// dismissed it from Home in a different session).
class TimelineDetailScreen extends ConsumerWidget {
  const TimelineDetailScreen({required this.stepId, super.key});

  final String stepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = ref.watch(timelineProvider).value ?? const [];
    final step = steps.where((s) => s.id == stepId).firstOrNull;

    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Timeline Step'),
      content: step == null
          ? const EmptyState(
              icon: Icons.timeline_outlined,
              message: 'This step is no longer on your timeline',
            )
          : FadeSlideIn(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(step.icon, size: 48, color: step.dotColor),
                  const SizedBox(height: AppSpacing.lg),
                  Text(step.label, style: context.textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    step.time,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
      ctaButton: step == null
          ? null
          : PrimaryButton(
              label: 'Remove from Timeline',
              onPressed: () {
                ref.read(timelineProvider.notifier).dismiss(step.id);
                context.pop();
              },
            ),
    );
  }
}
