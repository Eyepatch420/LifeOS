/// Reserved seam for OS-level background execution (periodic sync, daily
/// reset, etc.). Empty scaffold only — see docs/background_services_plan.md
/// (Phase 6 deliverable) for the real design before implementing this.
/// Registered in GetIt now so dependents can reference a stable type rather
/// than inventing an ad-hoc alternative while this is unimplemented.
abstract interface class BackgroundService {
  Future<void> initialize();
}

class NoopBackgroundService implements BackgroundService {
  const NoopBackgroundService();

  @override
  Future<void> initialize() async {}
}
