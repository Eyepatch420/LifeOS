/// Reserved seam for the Focus feature's timer (Phase 4). A true OS
/// foreground service is a Phase 6 planning concern
/// (docs/background_services_plan.md); this scaffold only fixes the
/// interface shape so `features/focus` has something concrete to build on
/// rather than inventing its own ad-hoc timer type.
abstract interface class ForegroundTimer {
  Stream<Duration> get elapsed;

  void start();
  void pause();
  void resume();
  void stop();
}

class NoopForegroundTimer implements ForegroundTimer {
  const NoopForegroundTimer();

  @override
  Stream<Duration> get elapsed => const Stream.empty();

  @override
  void start() {}

  @override
  void pause() {}

  @override
  void resume() {}

  @override
  void stop() {}
}
