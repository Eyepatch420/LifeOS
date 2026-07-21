import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/dnd_service.dart';
import 'package:lifeos/features/focus/data/focus_dnd_coordinator.dart';

/// Instantiates the single [FocusDndCoordinator] for the app's lifetime —
/// same `keepAlive()` rationale as `notificationEngineProvider`. Read once
/// from `app.dart`; nothing needs to watch its value afterward.
final focusDndCoordinatorProvider = Provider<FocusDndCoordinator>((ref) {
  ref.keepAlive();
  final coordinator = FocusDndCoordinator(
    eventBus: ref.watch(eventBusProvider),
    dnd: const DndService(),
    preferences: ref.watch(preferencesServiceProvider),
  );
  ref.onDispose(coordinator.dispose);
  return coordinator;
});
