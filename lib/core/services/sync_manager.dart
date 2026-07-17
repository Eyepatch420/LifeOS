/// Reserved seam for a future remote-sync layer. LifeOS is offline-first
/// with no backend today — this scaffold exists purely so the
/// UI → Repository → Persistence pipeline has a defined hook to call into
/// once sync exists, instead of that decision being made ad hoc per
/// feature later.
abstract interface class SyncManager {
  Future<void> syncNow();
}

class NoopSyncManager implements SyncManager {
  const NoopSyncManager();

  @override
  Future<void> syncNow() async {}
}
