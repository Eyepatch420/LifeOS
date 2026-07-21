import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/constants/pref_keys.dart';
import 'package:lifeos/core/services/dnd_service.dart';

final dndServiceProvider = Provider<DndService>((ref) => const DndService());

/// The user's persisted opt-in for "silence notifications during Focus" —
/// separate from whether Android has actually granted Notification Policy
/// Access (that's checked live via [DndService.isPolicyAccessGranted] at
/// the point DND would be applied, not cached here). A user can opt in
/// before ever granting access; [FocusDndCoordinator] simply no-ops until
/// they do.
class FocusDndOptInNotifier extends Notifier<bool> {
  @override
  bool build() => ref
      .read(preferencesServiceProvider)
      .getBool(PrefKeys.focusDndOptIn, defaultValue: false);

  Future<void> setOptedIn(bool value) async {
    state = value;
    await ref
        .read(preferencesServiceProvider)
        .setBool(PrefKeys.focusDndOptIn, value);
  }
}

final focusDndOptInProvider = NotifierProvider<FocusDndOptInNotifier, bool>(
  FocusDndOptInNotifier.new,
);
