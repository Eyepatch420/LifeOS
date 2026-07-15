/// Base type for expected, recoverable failures surfaced from a repository.
/// Distinct from uncaught exceptions, which indicate a programming error.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

/// A read/write to local storage (SharedPreferences, secure storage, Drift)
/// failed.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to read or write local data.']);
}

/// A biometric capability check or authentication attempt failed.
final class BiometricFailure extends Failure {
  const BiometricFailure([super.message = 'Biometric authentication failed.']);
}

/// Input supplied by the user failed validation before being persisted.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
