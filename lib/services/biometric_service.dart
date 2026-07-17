import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Wraps [LocalAuthentication] so the rest of the app never touches the
/// plugin directly — makes the capability-check-before-enabling flow (see
/// [UserProfileNotifier.completeSetup]) and the unlock flow (see
/// `BiometricGate`) both testable via a fake implementation.
class BiometricService {
  BiometricService(this._localAuth);

  final LocalAuthentication _localAuth;

  /// Whether the device has biometric hardware AND the user has enrolled at
  /// least one biometric. Check this before letting the user turn the
  /// biometric-lock preference on — never persist the preference as enabled
  /// if this returns false, or the user could lock themselves out.
  ///
  /// The platform channel can throw (e.g. a desktop target missing the
  /// Keychain/Touch ID entitlement) rather than just returning false — that
  /// failure mode means "can't determine capability," which is
  /// indistinguishable from "not available" for our purposes. Never let it
  /// propagate and abort the caller's flow (see `completeSetup()`, which
  /// would otherwise never reach its final `context.goNamed` navigation).
  Future<bool> canAuthenticate() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!canCheck || !isDeviceSupported) return false;
      final available = await _localAuth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (error, stackTrace) {
      debugPrint(
        'BiometricService.canAuthenticate failed: $error\n$stackTrace',
      );
      return false;
    }
  }

  Future<bool> authenticate({String reason = 'Unlock LifeOS'}) {
    return _localAuth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }
}
