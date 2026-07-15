import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/animations/shared_motion.dart';

/// Full-width filled CTA button with a loading-state crossfade, a tactile
/// press response via [PressableScale], a desktop hover lift, and a
/// distinct animated disabled state (not just Material's default dimming).
///
/// Optional [color] override lets callers (e.g. onboarding's per-page
/// accent) drive the button's color without a bespoke button widget —
/// falls back to `context.colorScheme.primary`.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hovered = false;

  void _setHovered(bool hovered) {
    if (_hovered == hovered) return;
    setState(() => _hovered = hovered);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = !widget.isLoading && widget.onPressed != null;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    // Reduce Motion: keep the hover/press color signal, drop the scale lift.
    final hoverScale = (!reduceMotion && _hovered && enabled) ? 1.02 : 1.0;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedOpacity(
        duration: AppDurations.fast,
        curve: AppCurves.easeOutCubic,
        opacity: enabled ? 1 : 0.45,
        child: PressableScale(
          onTap: widget.isLoading ? null : widget.onPressed,
          child: AnimatedScale(
            scale: hoverScale,
            duration: AppDurations.fast,
            curve: AppCurves.easeOutCubic,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              curve: AppCurves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: (_hovered && enabled && !reduceMotion)
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : const [],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: color),
                  onPressed: widget.isLoading ? null : widget.onPressed,
                  child: AnimatedSwitcher(
                    duration: AppDurations.fast,
                    child: widget.isLoading
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(widget.label, key: const ValueKey('label')),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
