import 'dart:async';

import 'package:lifeos/core/constants/pref_keys.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/dnd_service.dart';
import 'package:lifeos/features/focus/domain/events/focus_events.dart';
import 'package:lifeos/services/preferences_service.dart';

/// Turns system Do Not Disturb on for the duration of an active Focus
/// session, entirely opt-in and entirely separate from the session's own
/// timing — see this feature's Phase 7.5 module notes. A user who declines
/// (or never grants) Notification Policy Access gets a Focus session that
/// behaves identically in every other respect; this coordinator only ever
/// adds a side effect on top; it is never on Focus's critical path.
///
/// Subscribes directly to [EventBus] rather than going through the
/// notification contributor pipeline — DND is not a notification, and this
/// keeps `NotificationContributor`/`NotificationScheduler` from having to
/// know DND exists.
class FocusDndCoordinator {
  FocusDndCoordinator({
    required EventBus eventBus,
    required this.dnd,
    required this.preferences,
  }) {
    _subscription = eventBus.events.listen(_handle);
  }

  final DndService dnd;
  final PreferencesService preferences;
  late final StreamSubscription<DomainEvent> _subscription;

  bool get _optedIn =>
      preferences.getBool(PrefKeys.focusDndOptIn, defaultValue: false);

  Future<void> _handle(DomainEvent event) async {
    if (event.sourceModule != 'focus') return;
    switch (event) {
      case FocusSessionStarted():
      case FocusSessionResumed():
        await _enable();
      case FocusSessionPaused():
      case FocusSessionCompleted():
      case FocusSessionCancelled():
        await _restore();
    }
  }

  Future<void> _enable() async {
    if (!_optedIn) return;
    // Already recorded a prior filter (e.g. a rapid pause->resume where
    // restore hasn't run yet) — don't overwrite it with DND's own filter,
    // or the eventual restore would leave DND stuck on.
    if (preferences.getString(PrefKeys.focusDndPriorFilter) != null) return;

    // The whole DND platform channel is wrapped in one try/catch, not just
    // the final write — isPolicyAccessGranted()/getInterruptionFilter() can
    // throw a PlatformException/MissingPluginException just as easily as
    // setInterruptionFilter() (no channel handler registered, plugin not
    // available on this platform, ...). This is a pure side effect on top
    // of Focus, never allowed to propagate and disrupt the session itself.
    try {
      if (!await dnd.isPolicyAccessGranted()) return;
      final current = await dnd.getInterruptionFilter();
      await preferences.setString(
        PrefKeys.focusDndPriorFilter,
        current.index.toString(),
      );
      await dnd.setInterruptionFilter(InterruptionFilter.priority);
    } on Object {
      // Covers both PlatformException (policy access revoked between the
      // check above and this call, or another platform-level failure) and
      // MissingPluginException (no handler registered for this channel at
      // all — e.g. a platform/test environment with no MainActivity
      // channel wired up). Either way, DND is best-effort.
    }
  }

  Future<void> _restore() async {
    final storedIndex = preferences.getString(PrefKeys.focusDndPriorFilter);
    if (storedIndex == null) return;
    await preferences.remove(PrefKeys.focusDndPriorFilter);

    try {
      if (!await dnd.isPolicyAccessGranted()) return;
      final filter = InterruptionFilter.values[int.parse(storedIndex)];
      await dnd.setInterruptionFilter(filter);
    } on Object {
      // Nothing more this coordinator can safely do — the prior-filter key
      // is already cleared above so a later reconciliation won't loop on
      // this permanently-failing restore. Covers PlatformException and
      // MissingPluginException — see _enable()'s doc comment.
    }
  }

  /// Call once at app startup (before any Focus session can start): if a
  /// prior-filter record exists but there's no way to know whether it was
  /// ever restored (the app was killed mid-session, crashed, or the OS
  /// force-stopped it), restore it now rather than leaving DND stuck on
  /// indefinitely. Safe to call even when nothing needs restoring.
  Future<void> reconcileOnStartup() => _restore();

  void dispose() => _subscription.cancel();
}
