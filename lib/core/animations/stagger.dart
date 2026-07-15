import 'package:lifeos/core/animations/durations.dart';

/// Computes the per-index start delay for a staggered entrance sequence
/// (e.g. the 4 overview cards, or a list of quick actions).
///
/// Kept as a pure function so both [StaggeredEntrance] and any bespoke
/// staggered animation can share the same pacing.
abstract final class Stagger {
  static const Duration _perItemDelay = Duration(milliseconds: 60);

  /// Delay before item [index] begins its own entrance animation.
  static Duration delayForIndex(int index, {Duration? perItemDelay}) {
    final step = perItemDelay ?? _perItemDelay;
    return step * index;
  }

  /// Total duration to fully reveal [itemCount] staggered items, given each
  /// item's own entrance animation takes [itemDuration].
  static Duration totalDuration(
    int itemCount, {
    Duration itemDuration = AppDurations.medium,
    Duration? perItemDelay,
  }) {
    if (itemCount == 0) return Duration.zero;
    return delayForIndex(itemCount - 1, perItemDelay: perItemDelay) +
        itemDuration;
  }
}
