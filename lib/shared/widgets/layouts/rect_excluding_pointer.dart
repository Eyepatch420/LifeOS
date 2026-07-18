import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Wraps [child] and makes it decline hit testing inside [excludedRect]
/// (in [child]'s own local coordinate space) whenever [excluding] is true.
///
/// Layout, painting, clipping, and scrolling are completely unaffected —
/// this only changes what [child]'s subtree reports back to a [Stack]'s
/// hit-test walk. `Stack.hitTestChildren` (via
/// `RenderBoxContainerDefaultsMixin.defaultHitTestChildren`) tests children
/// front-to-back and stops at the first one that reports a hit, so a
/// full-bleed sibling normally wins over anything painted behind it —
/// wrapping that sibling in this widget lets specific sub-regions of it
/// "fall through" to whatever is behind it in the `Stack` instead, without
/// making the sibling `IgnorePointer` everywhere (which would also disable
/// its own legitimate interactions, e.g. scrolling) or reordering the
/// `Stack` itself (which would flip paint order too).
///
/// Outside [excludedRect] (or whenever [excluding] is false, or
/// [excludedRect] is null), hit testing behaves exactly as it would without
/// this wrapper.
class RectExcludingPointer extends SingleChildRenderObjectWidget {
  const RectExcludingPointer({
    required this.excludedRect,
    required this.excluding,
    super.child,
    super.key,
  });

  /// Region, in [child]'s local coordinate space, to decline hits within.
  /// `null` means there is nothing to exclude (equivalent to [excluding]
  /// being false).
  final Rect? excludedRect;

  /// Whether the exclusion is currently active. Kept separate from
  /// [excludedRect] so callers can flip this off without having to also
  /// discard/recompute the measured rect.
  final bool excluding;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRectExcludingPointer(
      excludedRect: excludedRect,
      excluding: excluding,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderRectExcludingPointer renderObject,
  ) {
    renderObject
      ..excludedRect = excludedRect
      ..excluding = excluding;
  }
}

/// The render object backing [RectExcludingPointer]. Public because
/// [SingleChildRenderObjectElement]'s `updateRenderObject` override
/// requires a public parameter type.
class RenderRectExcludingPointer extends RenderProxyBox {
  RenderRectExcludingPointer({
    required this.excludedRect,
    required this.excluding,
  });

  Rect? excludedRect;
  bool excluding;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final rect = excludedRect;
    if (excluding && rect != null && rect.contains(position)) {
      // Decline the hit ourselves — the Stack's hit-test walk then falls
      // through to the previous (earlier-painted) Stack child instead.
      return false;
    }
    return super.hitTest(result, position: position);
  }
}
