import 'package:flutter/material.dart';
import 'package:lifeos/core/extensions/datetime_extensions.dart';

/// A tint overlay applied only to the Home hero section, layered on top of
/// the (unchanging) hero background SVG — see `home_hero_section.dart`.
/// Kept separate from [WorkspaceTheme]/[ColorScheme] so the rest of the
/// app's coloring stays stable and predictable across the day.
@immutable
class TimeOfDayTint {
  const TimeOfDayTint({
    required this.gradient,
    required this.greeting,
    required this.bucket,
  });

  final List<Color> gradient;
  final String greeting;

  /// Stable identity for this tint, used as the animation key when
  /// cross-fading between buckets (see `GradientHeroBackground`) — keying
  /// on this enum instead of the `greeting` string means a future
  /// locale/copy change can't silently break the cross-fade.
  final TimeOfDayBucket bucket;
}

const Map<TimeOfDayBucket, List<Color>> _tintGradients = {
  TimeOfDayBucket.morning: [Color(0x992F6FED), Color(0x664FA8F0)],
  TimeOfDayBucket.afternoon: [Color(0x994FA8F0), Color(0x6683C9F5)],
  TimeOfDayBucket.evening: [Color(0x997A5CC9), Color(0x664F3B8F)],
  TimeOfDayBucket.night: [Color(0x99101B3D), Color(0x66223061)],
};

TimeOfDayTint timeOfDayTintFor(DateTime now) {
  final bucket = now.timeOfDayBucket;
  return TimeOfDayTint(
    gradient: _tintGradients[bucket]!,
    greeting: bucket.greeting,
    bucket: bucket,
  );
}
