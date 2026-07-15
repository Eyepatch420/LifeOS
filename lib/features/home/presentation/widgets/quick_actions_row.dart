import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/shared/widgets/buttons/circular_action_button.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

/// Stays purely presentational: callbacks are passed in via
/// [onActionTap]/[onViewAll], never read from a provider. Future modules
/// wire real navigation by editing `HomeScreen`'s callback map — this
/// widget never changes.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    required this.actions,
    required this.onActionTap,
    required this.onViewAll,
    super.key,
  });

  final List<QuickAction> actions;
  final Map<String, VoidCallback> onActionTap;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Quick Actions', onViewAll: onViewAll),
        const SizedBox(height: AppSpacing.md),
        if (actions.isEmpty)
          const EmptyState(
            icon: Icons.bolt_outlined,
            message: 'No quick actions configured',
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final action in actions)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xl),
                    child: CircularActionButton(
                      icon: action.icon,
                      label: action.label,
                      // A missing key is a safe no-op, not a crash — lets
                      // an action exist in the mock/registry set before its
                      // real feature screen is built.
                      onTap: () => onActionTap[action.id]?.call(),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
