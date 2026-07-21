import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/notifications/notification_engine.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/core/services/dnd_service.dart';
import 'package:lifeos/core/services/notification_scheduler.dart';
import 'package:lifeos/features/focus/data/focus_dnd_coordinator.dart';
import 'package:lifeos/features/focus/data/repositories/focus_repository.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_notification_contributor.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles a Focus ongoing-notification action (Pause/Resume/End) tapped
/// while LifeOS's foreground UI is not running. Registered as the
/// `onDidReceiveBackgroundNotificationResponse` top-level function in
/// `notification_scheduler.dart`'s `initialize()` — per
/// `flutter_local_notifications`' own contract, Android spawns a brand new,
/// separate Flutter engine/isolate to run this, with no access to the
/// foreground app's `ProviderContainer`/`GetIt`/open DB connection.
///
/// Deliberately reuses the exact same domain classes the foreground app
/// uses ([FocusRepository], [FocusNotificationContributor],
/// [NotificationEngine], [FocusDndCoordinator]) rather than re-implementing
/// any business logic here — this function's only job is composing fresh
/// instances of them for this isolate's lifetime, identical in shape to
/// what `main.dart`/`app.dart` do for the foreground isolate. The
/// completion alarm, ongoing-notification display, and DND state all stay
/// synchronized because they're driven by the same
/// [FocusRepository]-emitted events either isolate would produce.
@pragma('vm:entry-point')
Future<void> handleFocusNotificationAction(NotificationResponse response) async {
  final actionId = response.actionId;
  if (actionId == null) return;
  final parts = actionId.split(':');
  if (parts.length != 3 || parts[0] != 'action') return;
  final kind = parts[1];
  final sessionId = parts[2];

  final db = AppDatabase();
  final eventBus = EventBus();
  const clock = SystemClockManager();
  final repository = FocusRepository(db.focusSessionsDao, eventBus, clock);

  final scheduler = LocalNotificationScheduler(FlutterLocalNotificationsPlugin());
  await scheduler.initialize();
  final preferences = PreferencesService(await SharedPreferences.getInstance());

  final engine = NotificationEngine(
    eventBus: eventBus,
    contributors: const [FocusNotificationContributor()],
    scheduler: scheduler,
    notificationsDao: db.notificationsDao,
    idFactory: () => clock.now().microsecondsSinceEpoch.toString(),
  );
  final dndCoordinator = FocusDndCoordinator(
    eventBus: eventBus,
    dnd: const DndService(),
    preferences: preferences,
  );

  try {
    switch (kind) {
      case 'pause':
        await repository.pauseSession(sessionId);
      case 'resume':
        await repository.resumeSession(sessionId);
      case 'end':
        await repository.completeSession(sessionId);
    }
    // NotificationEngine/FocusDndCoordinator react to the event
    // asynchronously off the EventBus stream — give that a turn to run
    // before this isolate is torn down, or the reschedule/ongoing-update
    // side effects would never actually execute.
    await Future<void>.delayed(Duration.zero);
  } catch (error, stackTrace) {
    // A background isolate has nowhere to surface this to the user — the
    // worst case is the notification/DND state falls behind until the
    // user next opens the app, where FocusController/FocusDndCoordinator's
    // own startup reconciliation catches up. Never let this crash the
    // isolate silently without at least a debug trace.
    debugPrint('handleFocusNotificationAction($kind) failed: $error\n$stackTrace');
  } finally {
    engine.dispose();
    dndCoordinator.dispose();
    eventBus.dispose();
    await db.close();
  }
}
