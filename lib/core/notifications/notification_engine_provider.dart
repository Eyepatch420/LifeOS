import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/config/di/notification_contributor_registrations.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/notifications/notification_engine.dart';

/// Instantiates the single [NotificationEngine] for the app's lifetime —
/// `keepAlive()` since it must stay subscribed to [eventBusProvider] for as
/// long as the app runs, not just while some screen watches it. Read once
/// (e.g. from `main.dart`/`app.dart`) to start the subscription; nothing
/// needs to watch its value afterward.
final notificationEngineProvider = Provider<NotificationEngine>((ref) {
  ref.keepAlive();
  final engine = NotificationEngine(
    eventBus: ref.watch(eventBusProvider),
    contributors: notificationContributors(ref),
    scheduler: ref.watch(notificationSchedulerProvider),
    notificationsDao: ref.watch(databaseProvider).notificationsDao,
    // Matches the existing app-wide id convention (see
    // `new_note_screen.dart`'s `CreateNoteRequest.id`) — no new id-generation
    // dependency needed.
    idFactory: () => DateTime.now().microsecondsSinceEpoch.toString(),
  );
  ref.onDispose(engine.dispose);
  return engine;
});
