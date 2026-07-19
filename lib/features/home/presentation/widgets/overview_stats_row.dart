import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/shared/responsive/breakpoints.dart';
import 'package:lifeos/shared/widgets/cards/stat_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

/// The overview stat cards, reflowing from a 2x2 grid on phone to a single
/// row on tablet widths. The card **set** is provider-driven (see
/// `overviewStatsProvider`) — this widget never hardcodes which stats
/// exist, so swapping the set (personalization, a different module) is a
/// provider change, not a widget change.
class OverviewStatsRow extends StatelessWidget {
  const OverviewStatsRow({required this.stats, super.key});

  final List<OverviewStat> stats;

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const EmptyState(
        icon: Icons.bar_chart_outlined,
        message: 'No stats yet',
      );
    }

    final accent = context.colorScheme.primary;

    Widget buildCard(OverviewStat stat) {
      return StatCard(
        icon: stat.icon,
        label: stat.label,
        value: stat.value,
        subtitle: stat.subtitle,
        progress: stat.progress,
        accentColor: accent,
        onTap: stat.onTap,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= kTabletBreakpoint;
        // A fixed-aspect-ratio GridView can't adapt cell height to content
        // that grows with text scaling, so lay this out as rows of
        // Expanded cells instead — each StatCard sizes to its own natural
        // (intrinsic) height rather than being squeezed into a fixed cell.
        final columns = isTablet ? stats.length.clamp(1, 4) : 2;

        final rows = <Widget>[];
        for (var i = 0; i < stats.length; i += columns) {
          final rowStats = stats.skip(i).take(columns).toList();
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var j = 0; j < rowStats.length; j++) ...[
                    if (j > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(child: buildCard(rowStats[j])),
                  ],
                  // Pad a short trailing row so its cards stay half-width
                  // instead of stretching to fill the row alone.
                  if (rowStats.length < columns)
                    for (var k = rowStats.length; k < columns; k++) ...[
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(child: SizedBox()),
                    ],
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              rows[i],
            ],
          ],
        );
      },
    );
  }
}
