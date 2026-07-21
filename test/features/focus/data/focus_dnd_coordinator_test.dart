import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/constants/pref_keys.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/dnd_service.dart';
import 'package:lifeos/features/focus/data/focus_dnd_coordinator.dart';
import 'package:lifeos/features/focus/domain/events/focus_events.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fakes the `com.lifeos/dnd` platform channel so these tests never touch a
/// real Android `NotificationManager` — mirrors how `DndService` itself is
/// just a thin `MethodChannel` wrapper with no logic of its own to fake
/// around.
class _FakeDndChannel {
  bool policyAccessGranted = true;
  InterruptionFilter currentFilter = InterruptionFilter.all;
  final List<InterruptionFilter> setFilterCalls = [];

  MethodChannel install() {
    final channel = const MethodChannel('com.lifeos/dnd');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          switch (call.method) {
            case 'isPolicyAccessGranted':
              return policyAccessGranted;
            case 'getInterruptionFilter':
              return currentFilter.index;
            case 'setInterruptionFilter':
              if (!policyAccessGranted) {
                throw PlatformException(code: 'POLICY_ACCESS_DENIED');
              }
              final args = call.arguments as Map<Object?, Object?>;
              final filter = InterruptionFilter.values[args['filter']! as int];
              setFilterCalls.add(filter);
              currentFilter = filter;
              return null;
            case 'openPolicyAccessSettings':
              return null;
          }
          return null;
        });
    return channel;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeDndChannel fakeChannel;
  late DndService dnd;
  late PreferencesService preferences;
  late EventBus eventBus;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = PreferencesService(await SharedPreferences.getInstance());
    fakeChannel = _FakeDndChannel();
    dnd = DndService(fakeChannel.install());
    eventBus = EventBus();
  });

  tearDown(() {
    eventBus.dispose();
  });

  FocusDndCoordinator build() =>
      FocusDndCoordinator(eventBus: eventBus, dnd: dnd, preferences: preferences);

  test('does nothing on session start when the user has not opted in', () async {
    final coordinator = build();
    fakeChannel.currentFilter = InterruptionFilter.all;

    eventBus.emit(
      FocusSessionStarted(sessionId: 's1', projectedEndAt: DateTime(2026)),
    );
    await pumpEventQueue();

    expect(fakeChannel.setFilterCalls, isEmpty);
    coordinator.dispose();
  });

  test(
    'enables priority-only DND on start when opted in and policy access is '
    'granted, recording the prior filter for restore',
    () async {
      await preferences.setBool(PrefKeys.focusDndOptIn, true);
      fakeChannel.currentFilter = InterruptionFilter.all;
      final coordinator = build();

      eventBus.emit(
        FocusSessionStarted(sessionId: 's1', projectedEndAt: DateTime(2026)),
      );
      await pumpEventQueue();

      expect(fakeChannel.setFilterCalls, [InterruptionFilter.priority]);
      expect(
        preferences.getString(PrefKeys.focusDndPriorFilter),
        InterruptionFilter.all.index.toString(),
      );
      coordinator.dispose();
    },
  );

  test('does nothing when opted in but policy access was never granted', () async {
    await preferences.setBool(PrefKeys.focusDndOptIn, true);
    fakeChannel.policyAccessGranted = false;
    final coordinator = build();

    eventBus.emit(
      FocusSessionStarted(sessionId: 's1', projectedEndAt: DateTime(2026)),
    );
    await pumpEventQueue();

    expect(fakeChannel.setFilterCalls, isEmpty);
    coordinator.dispose();
  });

  test('restores the recorded prior filter on pause', () async {
    await preferences.setBool(PrefKeys.focusDndOptIn, true);
    fakeChannel.currentFilter = InterruptionFilter.alarms;
    final coordinator = build();

    eventBus.emit(
      FocusSessionStarted(sessionId: 's1', projectedEndAt: DateTime(2026)),
    );
    await pumpEventQueue();
    expect(fakeChannel.setFilterCalls, [InterruptionFilter.priority]);

    eventBus.emit(const FocusSessionPaused(sessionId: 's1'));
    await pumpEventQueue();

    expect(fakeChannel.setFilterCalls.last, InterruptionFilter.alarms);
    expect(preferences.getString(PrefKeys.focusDndPriorFilter), isNull);
    coordinator.dispose();
  });

  test('restores the recorded prior filter on complete and on cancel', () async {
    await preferences.setBool(PrefKeys.focusDndOptIn, true);
    final coordinator = build();

    eventBus.emit(
      FocusSessionStarted(sessionId: 's1', projectedEndAt: DateTime(2026)),
    );
    await pumpEventQueue();
    eventBus.emit(const FocusSessionCompleted(sessionId: 's1'));
    await pumpEventQueue();

    expect(preferences.getString(PrefKeys.focusDndPriorFilter), isNull);
    expect(fakeChannel.setFilterCalls.last, InterruptionFilter.all);
    coordinator.dispose();
  });

  test(
    'reconcileOnStartup restores DND if a prior-filter record was left '
    'behind by a crash/kill, without needing a live Focus session',
    () async {
      await preferences.setString(
        PrefKeys.focusDndPriorFilter,
        InterruptionFilter.priority.index.toString(),
      );
      final coordinator = build();

      await coordinator.reconcileOnStartup();

      expect(fakeChannel.setFilterCalls, [InterruptionFilter.priority]);
      expect(preferences.getString(PrefKeys.focusDndPriorFilter), isNull);
      coordinator.dispose();
    },
  );

  test('reconcileOnStartup is a no-op when nothing was left stuck', () async {
    final coordinator = build();

    await coordinator.reconcileOnStartup();

    expect(fakeChannel.setFilterCalls, isEmpty);
    coordinator.dispose();
  });

  test(
    'a resume immediately after start does not overwrite the already-'
    'recorded prior filter with DND\'s own filter',
    () async {
      await preferences.setBool(PrefKeys.focusDndOptIn, true);
      fakeChannel.currentFilter = InterruptionFilter.alarms;
      final coordinator = build();

      eventBus.emit(
        FocusSessionStarted(sessionId: 's1', projectedEndAt: DateTime(2026)),
      );
      await pumpEventQueue();
      eventBus.emit(
        FocusSessionResumed(sessionId: 's1', projectedEndAt: DateTime(2026)),
      );
      await pumpEventQueue();

      // Still records the original 'alarms' filter, not 'priority' (DND's
      // own filter, which is what currentFilter became after the first
      // _enable call).
      expect(
        preferences.getString(PrefKeys.focusDndPriorFilter),
        InterruptionFilter.alarms.index.toString(),
      );
      coordinator.dispose();
    },
  );
}
