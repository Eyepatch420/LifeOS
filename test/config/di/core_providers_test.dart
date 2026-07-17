import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/services/clock_manager.dart';

class _FakeClockManager implements ClockManager {
  _FakeClockManager(this._now);

  DateTime _now;

  void set(DateTime value) => _now = value;

  @override
  DateTime now() => _now;
}

void main() {
  test('todayProvider emits the clock\'s current localDateKey', () async {
    final clock = _FakeClockManager(DateTime(2026, 7, 16, 9));
    final container = ProviderContainer(
      overrides: [clockManagerProvider.overrideWithValue(clock)],
    );
    addTearDown(container.dispose);

    // Hold a listener open for the read's lifetime — StreamProvider is
    // auto-dispose by default (Riverpod 3.x default), so a bare
    // container.read(...future) taken with no active listener races the
    // provider's own disposal, the same pattern documented in
    // implemented_features.md's Phase 2 test notes.
    final sub = container.listen(todayProvider, (_, _) {});
    addTearDown(sub.close);

    final today = await container.read(todayProvider.future);
    expect(today, '2026-07-16');
  });

  test('todayProvider pads single-digit month/day', () async {
    final clock = _FakeClockManager(DateTime(2026, 1, 5));
    final container = ProviderContainer(
      overrides: [clockManagerProvider.overrideWithValue(clock)],
    );
    addTearDown(container.dispose);

    final sub = container.listen(todayProvider, (_, _) {});
    addTearDown(sub.close);

    final today = await container.read(todayProvider.future);
    expect(today, '2026-01-05');
  });

  test('clockManagerProvider is overridable with a test double', () {
    final clock = _FakeClockManager(DateTime(2026, 7, 16));
    final container = ProviderContainer(
      overrides: [clockManagerProvider.overrideWithValue(clock)],
    );
    addTearDown(container.dispose);

    expect(container.read(clockManagerProvider), same(clock));
  });
}
