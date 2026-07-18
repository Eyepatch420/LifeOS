import 'package:flutter/material.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/reminders/domain/planner/planner_day_data.dart';

/// Compact, visually-secondary summary line for the selected day — "X
/// scheduled, Y pending" plus an overdue count when relevant. Deliberately
/// does not report any "completed history" metric for recurring reminders
/// beyond what's on-screen (see `plannerDayFor`'s doc comment on the
/// single-row model's historical-occurrence limitation) — every number
/// shown here is directly counted from [data], never inferred.
class PlannerDaySummary extends StatelessWidget {
  const PlannerDaySummary({required this.data, super.key});

  final PlannerDayData data;

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      '${data.totalCount} scheduled',
      '${data.pendingCount} pending',
    ];
    if (data.overdueCarryover.isNotEmpty) {
      parts.add('${data.overdueCarryover.length} overdue');
    }

    return Text(
      parts.join(' · '),
      style: context.textTheme.labelMedium?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
