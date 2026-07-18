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

// Opaque enough (min ~75% alpha) to fully subdue the light-cyan sky SVG
// beneath, since it never darkens on its own — white hero text/icons need
// this floor of contrast at every bucket, not just night.
const Map<TimeOfDayBucket, List<Color>> _tintGradients = {
  TimeOfDayBucket.morning: [Color(0xCC2F6FED), Color(0xB2355FA6)],
  TimeOfDayBucket.afternoon: [Color(0xCC2E6FBF), Color(0xB23A6E96)],
  TimeOfDayBucket.evening: [Color(0xD9563E9E), Color(0xCC2E1E5E)],
  TimeOfDayBucket.night: [Color(0xF0101B3D), Color(0xE0141C33)],
};

TimeOfDayTint timeOfDayTintFor(DateTime now) {
  final bucket = now.timeOfDayBucket;
  return TimeOfDayTint(
    gradient: _tintGradients[bucket]!,
    greeting: bucket.greeting,
    bucket: bucket,
  );
}
