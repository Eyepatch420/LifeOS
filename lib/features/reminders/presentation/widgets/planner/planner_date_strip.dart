import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/theme/workspace_theme.dart';

/// Compact horizontal 7-day strip centered on [selectedDate], scrollable so
/// it never overflows regardless of screen width (see Phase 5 plan's
/// responsive requirement) rather than forcing a 7-column row into a fixed
/// width. Selection uses the workspace accent (see [theme]); today gets a
/// secondary indicator dot when it isn't the selected day.
class PlannerDateStrip extends StatelessWidget {
  const PlannerDateStrip({
    required this.selectedDate,
    required this.onDateSelected,
    required this.theme,
    super.key,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final WorkspaceTheme theme;

  @override
  Widget build(BuildContext context) {
    final today = dateOnly(DateTime.now());
    final start = selectedDate.subtract(const Duration(days: 3));
    final days = List.generate(7, (i) => start.add(Duration(days: i)));

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = day == selectedDate;
          final isToday = day == today;
          return Semantics(
            button: true,
            selected: isSelected,
            label: DateFormat('EEEE, d MMMM').format(day),
            child: PressableScale(
              onTap: () => onDateSelected(day),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                curve: AppCurves.easeOutCubic,
                width: 44,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.primary
                      : context.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE').format(day),
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${day.day}',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : context.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 4,
                      width: 4,
                      child: isToday && !isSelected
                          ? DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.primary,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
