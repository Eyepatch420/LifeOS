/// Thin wrapper over [DateTime.now] so time-dependent code (today's local
/// date, day-boundary checks) goes through one seam instead of calling
/// `DateTime.now()` ad hoc — a future test double or timezone-aware
/// implementation is a one-class change. Unlike the other `core/services`
/// scaffolds this one is not a no-op: `todayProvider` depends on it today.
abstract interface class ClockManager {
  DateTime now();
}

class SystemClockManager implements ClockManager {
  const SystemClockManager();

  @override
  DateTime now() => DateTime.now();
}
