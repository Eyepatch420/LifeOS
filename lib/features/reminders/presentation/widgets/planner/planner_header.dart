import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/utils/date_only.dart';

/// "Today" / "Tomorrow" / "Yesterday" / full weekday label for the
/// selected date, plus previous/next/Today controls. Today is only
/// visually emphasized (shown) when the selected date isn't already today
/// — see Phase 5 plan's requirement that the action not compete for
/// attention when it wouldn't do anything.
class PlannerHeader extends StatelessWidget {
  const PlannerHeader({
    required this.selectedDate,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onToday,
    super.key,
  });

  final DateTime selectedDate;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final today = dateOnly(DateTime.now());
    final isToday = selectedDate == today;
    final label = _labelFor(selectedDate, today);

    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Previous day',
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.chevron_left),
            onPressed: onPreviousDay,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                DateFormat('EEEE, d MMMM').format(selectedDate),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Semantics(
          button: true,
          label: 'Next day',
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextDay,
          ),
        ),
        if (!isToday)
          Semantics(
            button: true,
            label: 'Jump to today',
            child: PressableScale(
              onTap: onToday,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                ),
                child: Text(
                  'Today',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _labelFor(DateTime date, DateTime today) {
    final dayDiff = date.difference(today).inDays;
    if (dayDiff == 0) return 'Today';
    if (dayDiff == 1) return 'Tomorrow';
    if (dayDiff == -1) return 'Yesterday';
    return DateFormat('EEEE').format(date);
  }
}
