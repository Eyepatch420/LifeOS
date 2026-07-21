import 'package:flutter/services.dart';

/// Android's user-visible interruption levels — mirrors
/// `NotificationManager.INTERRUPTION_FILTER_*` exactly (see
/// `MainActivity.kt`'s channel handler). `unknown` is what Android reports
/// before Notification Policy Access has ever been granted/queried.
enum InterruptionFilter { unknown, all, priority, none, alarms }

InterruptionFilter _filterFromInt(int? value) => switch (value) {
  1 => InterruptionFilter.all,
  2 => InterruptionFilter.priority,
  3 => InterruptionFilter.none,
  4 => InterruptionFilter.alarms,
  _ => InterruptionFilter.unknown,
};

int _filterToInt(InterruptionFilter filter) => switch (filter) {
  InterruptionFilter.unknown => 0,
  InterruptionFilter.all => 1,
  InterruptionFilter.priority => 2,
  InterruptionFilter.none => 3,
  InterruptionFilter.alarms => 4,
};

/// Thin wrapper over the `com.lifeos/dnd` platform channel — see
/// `MainActivity.kt`. Android only allows a third-party app to control
/// system-wide Do Not Disturb (`NotificationManager.setInterruptionFilter`)
/// after the user has explicitly granted Notification Policy Access via a
/// settings screen this app cannot skip or auto-grant.
///
/// Deliberately does NOT touch (and cannot legitimately touch) the separate
/// Digital Wellbeing "Focus Mode" — Android has no public API for a
/// third-party app to toggle that; this service only ever talks to DND.
class DndService {
  const DndService([this._channel = const MethodChannel('com.lifeos/dnd')]);

  final MethodChannel _channel;

  Future<bool> isPolicyAccessGranted() async {
    final granted = await _channel.invokeMethod<bool>('isPolicyAccessGranted');
    return granted ?? false;
  }

  /// Opens Android's Notification Policy Access settings screen so the user
  /// can grant it. Fire-and-forget — the app has no way to know the
  /// decision until it re-checks [isPolicyAccessGranted] on resume.
  Future<void> openPolicyAccessSettings() =>
      _channel.invokeMethod<void>('openPolicyAccessSettings');

  Future<InterruptionFilter> getInterruptionFilter() async {
    final value = await _channel.invokeMethod<int>('getInterruptionFilter');
    return _filterFromInt(value);
  }

  /// Throws a [PlatformException] with code `POLICY_ACCESS_DENIED` if the
  /// user hasn't granted Notification Policy Access — callers must check
  /// [isPolicyAccessGranted] first and treat a denial as "DND unavailable,
  /// proceed without it" rather than surfacing this as an error.
  Future<void> setInterruptionFilter(InterruptionFilter filter) {
    return _channel.invokeMethod<void>('setInterruptionFilter', {
      'filter': _filterToInt(filter),
    });
  }
}
