import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/health/domain/models/create_habit_request.dart';
import 'package:lifeos/features/health/presentation/providers/habit_providers.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('habitRequestsProvider starts empty', () async {
    final container = makeContainer();
    expect(await container.read(habitRequestsProvider.future), isEmpty);
  });

  test('addHabit appends to the list', () async {
    final container = makeContainer();
    await container.read(habitRequestsProvider.future);

    final habit = CreateHabitRequest(
      id: '1',
      title: 'Drink water',
      targetFrequency: 'Daily',
    );
    await container.read(habitRequestsProvider.notifier).addHabit(habit);

    expect(container.read(habitRequestsProvider).value, [habit]);
  });
}
