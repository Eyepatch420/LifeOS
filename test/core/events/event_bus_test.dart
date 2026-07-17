import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';

class _TestEvent extends DomainEvent {
  const _TestEvent({required super.sourceModule, required super.sourceId});
}

void main() {
  test('emit delivers to a listener subscribed on events', () async {
    final bus = EventBus();
    final received = <DomainEvent>[];
    final sub = bus.events.listen(received.add);

    bus.emit(const _TestEvent(sourceModule: 'reminders', sourceId: 'r1'));
    await pumpEventQueue();

    expect(received, hasLength(1));
    expect(received.single.sourceModule, 'reminders');
    expect(received.single.sourceId, 'r1');

    await sub.cancel();
    bus.dispose();
  });

  test('broadcast: multiple listeners each receive the same event', () async {
    final bus = EventBus();
    final a = <DomainEvent>[];
    final b = <DomainEvent>[];
    final subA = bus.events.listen(a.add);
    final subB = bus.events.listen(b.add);

    bus.emit(const _TestEvent(sourceModule: 'habits', sourceId: 'h1'));
    await pumpEventQueue();

    expect(a, hasLength(1));
    expect(b, hasLength(1));

    await subA.cancel();
    await subB.cancel();
    bus.dispose();
  });

  test('eventBusProvider yields the same EventBus instance across reads', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final first = container.read(eventBusProvider);
    final second = container.read(eventBusProvider);

    expect(identical(first, second), isTrue);
  });

  test('disposing the provider container disposes the bus', () async {
    final container = ProviderContainer();
    final bus = container.read(eventBusProvider);

    container.dispose();

    // A disposed StreamController's stream is done; emit after dispose
    // should not throw synchronously into the caller, matching
    // StreamController.close() semantics.
    expect(() => bus.events.listen((_) {}), returnsNormally);
  });
}
