import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_dnd_settings_provider.dart';

/// "Silence notifications during Focus" — opt-in Do Not Disturb for the
/// duration of a session. Turning this on does not itself grant Android's
/// Notification Policy Access; it only records the user's preference
/// ([focusDndOptInProvider]). If access hasn't been granted, this also
/// prompts the user to the system settings screen — Android has no API for
/// an app to request that access any other way. Declining/ignoring that
/// prompt leaves the toggle on with no effect: [FocusDndCoordinator]
/// checks live access at session-start time and simply skips DND if it's
/// not granted, so Focus itself never depends on this succeeding.
class FocusDndToggle extends ConsumerWidget {
  const FocusDndToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optedIn = ref.watch(focusDndOptInProvider);

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Silence notifications during Focus'),
      subtitle: Text(
        'Turns on Do Not Disturb while a session is running',
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      value: optedIn,
      onChanged: (value) async {
        await ref.read(focusDndOptInProvider.notifier).setOptedIn(value);
        if (!value) return;
        final dnd = ref.read(dndServiceProvider);
        if (!await dnd.isPolicyAccessGranted()) {
          await dnd.openPolicyAccessSettings();
        }
      },
    );
  }
}
