import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/animations/stagger.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

class TimelineStepperCard extends StatelessWidget {
  const TimelineStepperCard({required this.steps, super.key});

  final List<TimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: "Today's Timeline"),
          const SizedBox(height: AppSpacing.lg),
          if (steps.isEmpty)
            const EmptyState(
              icon: Icons.timeline_outlined,
              message: 'Nothing scheduled today',
            )
          else
            SizedBox(
              height: 96,
              child: Row(
                children: [
                  for (var i = 0; i < steps.length; i++)
                    Expanded(
                      child: FadeSlideIn(
                        delay: Stagger.delayForIndex(
                          i,
                          perItemDelay: const Duration(milliseconds: 80),
                        ),
                        duration: AppMotionPresets.timeline.duration,
                        child: _TimelineStepWidget(
                          step: steps[i],
                          isLast: i == steps.length - 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineStepWidget extends StatelessWidget {
  const _TimelineStepWidget({required this.step, required this.isLast});

  final TimelineStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(step.time, style: context.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: isLast
                  ? const SizedBox()
                  : Divider(color: step.dotColor.withValues(alpha: 0.3)),
            ),
            Container(
              width: AppSpacing.timelineDotSize,
              height: AppSpacing.timelineDotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: step.dotColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Icon(step.icon, size: 18, color: step.dotColor),
        const SizedBox(height: AppSpacing.xs),
        Text(
          step.label,
          style: context.textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
