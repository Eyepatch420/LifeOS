import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';
import 'package:lifeos/features/reminders/domain/models/reminders_dashboard_data.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';

/// Ticks once a minute so Today/Upcoming/Overdue classification stays
/// correct across a midnight rollover during a long-lived session, without
/// requiring a manual refresh — mirrors `home_providers.dart`'s
/// `clockTickProvider` exactly, but kept local to this feature rather than
/// imported from Home: Home is allowed to depend on Reminders (via
/// `remindersDashboardProvider`), never the other way around (see the
/// Golden Rule in `reminders_repository.dart`'s doc comment).
///
/// `autoDispose` (unlike Home's `clockTickProvider`) so the underlying
/// `Stream.periodic` timer is cancelled once nothing watches this anymore
/// (e.g. when `RemindersDashboardScreen` unmounts) instead of ticking for
/// the lifetime of the `ProviderContainer` — this matters in widget tests,
/// where a non-autoDispose periodic timer can otherwise outlive the test
/// that created it and be picked up by `pumpAndSettle()` in a *later*
/// test sharing the same test-runner isolate.
final remindersClockTickProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream<DateTime>.periodic(
    const Duration(minutes: 1),
    (_) => DateTime.now(),
  ).startWith(DateTime.now());
});

extension<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}

/// The raw reminder list as an `AsyncValue`, watched by
/// [remindersDashboardDataProvider] below — kept as its own provider so
/// that provider can `ref.watch` it alongside [remindersClockTickProvider]
/// and recompute on whichever changes first, instead of a `StreamProvider`
/// that only reacts to one of its two inputs. `autoDispose` for the same
/// reason as [remindersClockTickProvider].
final _remindersListProvider = StreamProvider.autoDispose<List<Reminder>>((
  ref,
) {
  return ref.watch(remindersRepositoryProvider).watchAll();
});

/// The Reminders dashboard's derived presentation state: reclassifies the
/// live reminder stream into today/upcoming/overdue/upNext buckets
/// whenever either the reminder data changes OR the minute ticks over (so a
/// midnight rollover reclassifies without requiring any user action).
/// Pure derivation only — see [remindersForDashboard] for the
/// classification logic itself, which is unit-tested independently of
/// Riverpod. `autoDispose` for the same reason as
/// [remindersClockTickProvider].
final remindersDashboardDataProvider =
    Provider.autoDispose<AsyncValue<RemindersDashboardData>>((ref) {
      final remindersAsync = ref.watch(_remindersListProvider);
      final nowAsync = ref.watch(remindersClockTickProvider);

      return remindersAsync.when(
        data: (reminders) => nowAsync.when(
          data: (now) => AsyncData(remindersForDashboard(reminders, now: now)),
          loading: () => const AsyncLoading(),
          error: AsyncError.new,
        ),
        loading: () => const AsyncLoading(),
        error: AsyncError.new,
      );
    });
