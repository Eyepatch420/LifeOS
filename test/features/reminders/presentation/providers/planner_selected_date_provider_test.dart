import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/reminders/presentation/providers/planner_selected_date_provider.dart';

void main() {
  test('defaults to today (date-only, no time component)', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final today = DateTime.now();
    final selected = container.read(plannerSelectedDateProvider);

    expect(selected.year, today.year);
    expect(selected.month, today.month);
    expect(selected.day, today.day);
    expect(selected.hour, 0);
    expect(selected.minute, 0);
  });

  test('previousDay moves back exactly one calendar day', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final before = container.read(plannerSelectedDateProvider);
    container.read(plannerSelectedDateProvider.notifier).previousDay();
    final after = container.read(plannerSelectedDateProvider);

    expect(after, before.subtract(const Duration(days: 1)));
  });

  test('nextDay moves forward exactly one calendar day', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final before = container.read(plannerSelectedDateProvider);
    container.read(plannerSelectedDateProvider.notifier).nextDay();
    final after = container.read(plannerSelectedDateProvider);

    expect(after, before.add(const Duration(days: 1)));
  });

  test('selectDate normalizes to date-only, dropping any time component', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container
        .read(plannerSelectedDateProvider.notifier)
        .selectDate(DateTime(2026, 3, 5, 17, 42));
    final selected = container.read(plannerSelectedDateProvider);

    expect(selected, DateTime(2026, 3, 5));
  });

  test('resetToToday jumps back to the current date after navigating away', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(plannerSelectedDateProvider.notifier);
    notifier.selectDate(DateTime(2020, 1, 1));
    expect(container.read(plannerSelectedDateProvider), DateTime(2020, 1, 1));

    notifier.resetToToday();
    final today = DateTime.now();
    final selected = container.read(plannerSelectedDateProvider);
    expect(selected, DateTime(today.year, today.month, today.day));
  });
}
