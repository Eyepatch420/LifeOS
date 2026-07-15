import 'package:lifeos/core/error/failures.dart';

/// A value that is either a successful [T] or a [Failure] — repository
/// methods that can fail return this instead of throwing, so callers handle
/// failure explicitly rather than relying on try/catch at every call site.
sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Failure failure) = FailureResult<T>;

  bool get isSuccess => this is Success<T>;

  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.value);
    if (self is FailureResult<T>) return failure(self.failure);
    throw StateError('Unreachable: Result must be Success or FailureResult.');
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final Failure failure;
}
