import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/health/domain/models/create_habit_request.dart';

/// Mock in-memory store — mirrors `home_providers.dart`'s `AsyncNotifier`
/// pattern so swapping in a real repository later is a `build()`-body-only
/// change; no call-site changes anywhere.
class HabitRequestsNotifier extends AsyncNotifier<List<CreateHabitRequest>> {
  @override
  Future<List<CreateHabitRequest>> build() async => const [];

  Future<void> addHabit(CreateHabitRequest habit) async {
    state = AsyncData([...?state.value, habit]);
  }
}

final habitRequestsProvider =
    AsyncNotifierProvider<HabitRequestsNotifier, List<CreateHabitRequest>>(
      HabitRequestsNotifier.new,
    );
