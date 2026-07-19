import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Sensible focus-duration presets — kept as this feature's single owned
/// configuration point rather than scattered literals, so retuning the set
/// is a one-line change.
const List<int> kFocusDurationPresetsMinutes = [15, 25, 45, 60];

/// A horizontally wrapping row of duration-preset chips (never a fixed-width
/// row, so it reflows safely at 320px without overflow). [selectedMinutes]
/// highlights the active choice; [onSelected] fires with the tapped
/// preset's minute value.
class FocusDurationPicker extends StatelessWidget {
  const FocusDurationPicker({
    required this.selectedMinutes,
    required this.onSelected,
    super.key,
  });

  final int selectedMinutes;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final minutes in kFocusDurationPresetsMinutes)
          _DurationChip(
            minutes: minutes,
            selected: minutes == selectedMinutes,
            onTap: () => onSelected(minutes),
          ),
      ],
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    required this.minutes,
    required this.selected,
    required this.onTap,
  });

  final int minutes;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedColor = context.appColors.chipSelectedColor;

    return Semantics(
      button: true,
      selected: selected,
      label: '$minutes minutes',
      child: PressableScale(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected
                ? selectedColor
                : context.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$minutes min',
            style: context.textTheme.labelLarge?.copyWith(
              color: selected
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
