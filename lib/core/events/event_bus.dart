import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/events/domain_event.dart';

/// A broadcast stream of every [DomainEvent] emitted anywhere in the app.
/// Repositories call `ref.read(eventBusProvider).emit(...)`; subscribers
/// (the NotificationEngine first, later analytics/achievements) call
/// `ref.watch(eventBusProvider).events`. Broadcast so multiple subscribers
/// can listen without one consuming events meant for another.
class EventBus {
  final _controller = StreamController<DomainEvent>.broadcast();

  Stream<DomainEvent> get events => _controller.stream;

  void emit(DomainEvent event) => _controller.add(event);

  void dispose() => _controller.close();
}

final eventBusProvider = Provider<EventBus>((ref) {
  final bus = EventBus();
  ref.onDispose(bus.dispose);
  return bus;
});
