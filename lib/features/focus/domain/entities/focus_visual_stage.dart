/// The three visual "environments" an active Focus session's presentation
/// moves through as it progresses — a pure function of session progress
/// (`0.0`-`1.0`, from [FocusSession.progressAt]), never of wall-clock
/// minutes directly, so it scales to any planned duration (15/25/45/60
/// min, ...) automatically.
///
/// Deliberately lives in `domain/`, not `presentation/widgets/`: which
/// stage is "current" is a pure derivation from progress, with zero
/// knowledge of Lottie, `AnimationController`s, or any widget — the
/// presentation layer (`FocusVisualStagePresenter`) only ever asks "what
/// stage is this progress in," never derives it independently. This is the
/// seam that keeps the animation system from ever becoming a second source
/// of truth for session state.
enum FocusVisualStage {
  /// 0%-33%: "growing" — the session is just getting started.
  growing,

  /// 33%-66%: the middle stretch.
  ripening,

  /// 66%-100%: the home stretch toward completion.
  settling;

  static FocusVisualStage forProgress(double progress) {
    final clamped = progress.clamp(0.0, 1.0);
    if (clamped < 1 / 3) return FocusVisualStage.growing;
    if (clamped < 2 / 3) return FocusVisualStage.ripening;
    return FocusVisualStage.settling;
  }
}
