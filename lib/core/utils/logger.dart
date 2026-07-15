import 'package:flutter/foundation.dart';

/// Thin logging wrapper. Centralizing this call site means swapping in a
/// real crash-reporting/log-shipping backend later is a one-file change.
abstract final class AppLogger {
  static void debug(String message) {
    if (kDebugMode) {
      debugPrint('[LifeOS] $message');
    }
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[LifeOS] ERROR: $message${error != null ? ' — $error' : ''}');
      if (stackTrace != null) debugPrint(stackTrace.toString());
    }
  }
}
