import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/services/notification_tap_dispatcher.dart';

void main() {
  test('dispatch emits non-empty payloads on the taps stream', () async {
    final dispatcher = NotificationTapDispatcher();
    final received = <String>[];
    final sub = dispatcher.taps.listen(received.add);

    dispatcher.dispatch('focus:s1');
    dispatcher.dispatch(null);
    dispatcher.dispatch('');
    await pumpEventQueue();

    expect(received, ['focus:s1']);
    await sub.cancel();
    dispatcher.dispose();
  });

  test('dispatchAction emits non-empty action ids on the actions stream, '
      'separate from taps', () async {
    final dispatcher = NotificationTapDispatcher();
    final taps = <String>[];
    final actions = <String>[];
    final tapSub = dispatcher.taps.listen(taps.add);
    final actionSub = dispatcher.actions.listen(actions.add);

    dispatcher.dispatchAction('action:pause:s1');
    dispatcher.dispatchAction(null);
    dispatcher.dispatchAction('');
    await pumpEventQueue();

    expect(actions, ['action:pause:s1']);
    expect(taps, isEmpty);
    await tapSub.cancel();
    await actionSub.cancel();
    dispatcher.dispose();
  });
}
