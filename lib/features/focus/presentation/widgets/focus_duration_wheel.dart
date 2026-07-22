import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Preset Focus durations, in minutes — same set as before
/// (`kFocusDurationPresetsMinutes` in the old pill picker), extended with 90
/// to match this phase's spec.
const List<int> kFocusDurationPresetsMinutes = [15, 25, 45, 60, 90];

/// A vertical wheel selector for the preset Focus durations. The centered
/// item is the selection; items above/below shrink and fade with distance
/// via [ListWheelScrollView]'s built-in perspective/`useMagnifier`, so no
/// bespoke transform math is needed.
///
/// [onChanged] fires (and a subtle selection haptic ticks) only when the
/// centered item actually changes — not on every scroll pixel — mirroring
/// how `Cupertino`-style wheels are normally wired: track the last-known
/// selected index and only act when [ListWheelScrollView.onSelectedItemChanged]
/// reports a different one.
class FocusDurationWheel extends StatefulWidget {
  const FocusDurationWheel({
    required this.selectedMinutes,
    required this.onChanged,
    super.key,
  });

  final int selectedMinutes;
  final ValueChanged<int> onChanged;

  @override
  State<FocusDurationWheel> createState() => _FocusDurationWheelState();
}

class _FocusDurationWheelState extends State<FocusDurationWheel> {
  late final FixedExtentScrollController _controller;
  late int _lastIndex;

  static const _itemExtent = 56.0;

  @override
  void initState() {
    super.initState();
    _lastIndex = _indexForMinutes(widget.selectedMinutes);
    _controller = FixedExtentScrollController(initialItem: _lastIndex);
  }

  @override
  void didUpdateWidget(FocusDurationWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final targetIndex = _indexForMinutes(widget.selectedMinutes);
    if (targetIndex != _controller.selectedItem) {
      _lastIndex = targetIndex;
      _controller.jumpToItem(targetIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _indexForMinutes(int minutes) {
    final index = kFocusDurationPresetsMinutes.indexOf(minutes);
    return index == -1 ? 0 : index;
  }

  void _handleSelectedItemChanged(int index) {
    if (index == _lastIndex) return;
    _lastIndex = index;
    HapticFeedback.selectionClick();
    widget.onChanged(kFocusDurationPresetsMinutes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Focus duration, currently ${widget.selectedMinutes} minutes. '
          'Swipe up or down to change.',
      child: SizedBox(
        height: _itemExtent * 3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: _itemExtent,
              diameterRatio: 1.6,
              perspective: 0.003,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: _handleSelectedItemChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: kFocusDurationPresetsMinutes.length,
                builder: (context, index) {
                  final minutes = kFocusDurationPresetsMinutes[index];
                  final selected = index == _controller.selectedItem;
                  return Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 150),
                      style: selected
                          ? context.textTheme.displaySmall!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.onSurface,
                            )
                          : context.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: context.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                            ),
                      child: Text('$minutes min'),
                    ),
                  );
                },
              ),
            ),
            IgnorePointer(
              child: Container(
                height: _itemExtent,
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.colorScheme.outlineVariant),
                    bottom: BorderSide(
                      color: context.colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
