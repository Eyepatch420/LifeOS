import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/utils/duration_format.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';

const int _maxHours = 12;
const int _maxMinutes = 59;

/// Opens the custom-duration bottom sheet and resolves to the chosen
/// [Duration], or `null` if dismissed without confirming. [initial] seeds
/// both wheels so reopening the sheet resumes from the last custom value
/// rather than always starting at zero.
Future<Duration?> showFocusCustomDurationSheet(
  BuildContext context, {
  required Duration initial,
}) {
  return showModalBottomSheet<Duration>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _FocusCustomDurationSheet(initial: initial),
  );
}

class _FocusCustomDurationSheet extends StatefulWidget {
  const _FocusCustomDurationSheet({required this.initial});

  final Duration initial;

  @override
  State<_FocusCustomDurationSheet> createState() =>
      _FocusCustomDurationSheetState();
}

class _FocusCustomDurationSheetState extends State<_FocusCustomDurationSheet> {
  late int _hours;
  late int _minutes;
  late final FixedExtentScrollController _hoursController;
  late final FixedExtentScrollController _minutesController;

  @override
  void initState() {
    super.initState();
    _hours = widget.initial.inHours.clamp(0, _maxHours);
    _minutes = widget.initial.inMinutes.remainder(60).clamp(0, _maxMinutes);
    _hoursController = FixedExtentScrollController(initialItem: _hours);
    _minutesController = FixedExtentScrollController(initialItem: _minutes);
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  Duration get _selected => Duration(hours: _hours, minutes: _minutes);

  bool get _isValid => _selected > Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Custom Focus',
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'How long do you need?',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _Wheel(
                    label: 'HOURS',
                    controller: _hoursController,
                    itemCount: _maxHours + 1,
                    onChanged: (value) => setState(() => _hours = value),
                  ),
                ),
                Expanded(
                  child: _Wheel(
                    label: 'MINUTES',
                    controller: _minutesController,
                    itemCount: _maxMinutes + 1,
                    onChanged: (value) => setState(() => _minutes = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              _isValid ? _selected.toShortLabel : 'Select a duration',
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _isValid
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              button: true,
              label: 'Set duration, ${_selected.toShortLabel}',
              child: PrimaryButton(
                label: 'Set Duration',
                onPressed: _isValid
                    ? () => Navigator.of(context).pop(_selected)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Wheel extends StatefulWidget {
  const _Wheel({
    required this.label,
    required this.controller,
    required this.itemCount,
    required this.onChanged,
  });

  final String label;
  final FixedExtentScrollController controller;
  final int itemCount;
  final ValueChanged<int> onChanged;

  @override
  State<_Wheel> createState() => _WheelState();
}

class _WheelState extends State<_Wheel> {
  static const _itemExtent = 44.0;
  late int _lastIndex = widget.controller.initialItem;

  void _handleChanged(int index) {
    if (index == _lastIndex) return;
    _lastIndex = index;
    HapticFeedback.selectionClick();
    widget.onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
          style: context.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.onSurfaceVariant,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Semantics(
          label: '${widget.label.toLowerCase()} selector',
          child: SizedBox(
            height: _itemExtent * 3,
            child: ListWheelScrollView.useDelegate(
              controller: widget.controller,
              itemExtent: _itemExtent,
              diameterRatio: 1.4,
              perspective: 0.003,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: _handleChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.itemCount,
                builder: (context, index) {
                  final selected = index == widget.controller.selectedItem;
                  return Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 150),
                      style: selected
                          ? context.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w700,
                            )
                          : context.textTheme.titleMedium!.copyWith(
                              color: context.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                            ),
                      child: Text(index.toString().padLeft(2, '0')),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
