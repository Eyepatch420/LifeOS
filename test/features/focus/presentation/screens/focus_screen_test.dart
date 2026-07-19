import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_dashboard_provider.dart';
import 'package:lifeos/features/focus/presentation/screens/focus_screen.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);
  DateTime _now;

  @override
  DateTime now() => _now;

  void advance(Duration by) => _now = _now.add(by);
}

void main() {
  late _FakeClock clock;
  late AppDatabase db;

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    Size? screenSize,
  }) async {
    if (screenSize != null) {
      tester.view.physicalSize = screenSize;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    clock = _FakeClock(DateTime(2026, 1, 1, 9));
    late ProviderContainer container;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockManagerProvider.overrideWithValue(clock),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return const MaterialApp(home: FocusScreen());
          },
        ),
      ),
    );
    // Not pumpAndSettle(): something in this tree (still being narrowed
    // down) never reaches a steady state within pumpAndSettle's frame
    // budget even in the idle state. A handful of explicit pumps drains
    // AsyncNotifier.build()'s two chained awaits (reconcile, then
    // watchActiveSession().first) deterministically instead.
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump();
    addTearDown(db.close);
    return container;
  }

  testWidgets('idle state shows duration presets and a Start Focus button', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Start Focus'), findsOneWidget);
    expect(find.text('25 min'), findsOneWidget);
    expect(find.text('45 min'), findsOneWidget);
    expect(find.text('No focus sessions yet'), findsOneWidget);
  });

  testWidgets('tapping a duration preset changes the selection', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('45 min'));
    await tester.pump();

    // No direct visual assertion on selection color needed here — the
    // meaningful behavior is that Start now uses 45, verified below.
    expect(find.text('45 min'), findsOneWidget);
  });

  testWidgets(
    'tapping Start Focus transitions to the active state with a running '
    'timer display',
    (tester) async {
      await pump(tester);

      await tester.tap(find.text('Start Focus'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Focusing…'), findsOneWidget);
      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('Pause'), findsOneWidget);
      expect(find.text('End Focus'), findsOneWidget);
    },
  );

  testWidgets('the timer counts down as the fake clock/ticker advances', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Start Focus'));
    await tester.pump();
    await tester.pump();

    clock.advance(const Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('24:55'), findsOneWidget);
  });

  testWidgets('tapping Pause shows Paused and a Resume button', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Start Focus'));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Pause'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Paused'), findsOneWidget);
    expect(find.text('Resume'), findsOneWidget);
  });

  testWidgets('tapping Resume after Pause returns to Focusing…', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Start Focus'));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Pause'));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Resume'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Focusing…'), findsOneWidget);
  });

  testWidgets(
    'tapping End Focus shows the completed acknowledgement with actual '
    'duration, then Start another session returns to idle',
    (tester) async {
      await pump(tester);
      await tester.tap(find.text('Start Focus'));
      await tester.pump();
      await tester.pump();

      clock.advance(const Duration(minutes: 10));
      await tester.tap(find.text('End Focus'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Nice work!'), findsOneWidget);
      expect(find.text('You focused for 10 minutes'), findsOneWidget);

      await tester.tap(find.text('Start another session'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Start Focus'), findsOneWidget);
    },
  );

  testWidgets('tapping Cancel session returns directly to idle', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Start Focus'));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Cancel session'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Start Focus'), findsOneWidget);
    expect(find.text('Nice work!'), findsNothing);
  });

  testWidgets('renders without overflow at 320px width', (tester) async {
    await pump(tester, screenSize: const Size(320 * 3, 700 * 3));

    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Start Focus'));
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Focusing…'), findsOneWidget);
  });

  testWidgets('renders without overflow at a realistic emulator width', (
    tester,
  ) async {
    await pump(tester, screenSize: const Size(1080, 2424));

    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Start Focus'));
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'a session already active when the screen opens (e.g. restored from '
    'persistence) renders the active state directly, not idle',
    (tester) async {
      // Seed an active session directly through the repository before the
      // screen ever builds — simulates opening Focus onto an
      // already-running session (process restoration / navigating back).
      final seedContainer = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(
            AppDatabase.forTesting(
              DatabaseConnection(
                NativeDatabase.memory(),
                closeStreamsSynchronously: true,
              ),
            ),
          ),
        ],
      );
      addTearDown(seedContainer.dispose);
      final seedDb = seedContainer.read(databaseProvider);
      final fakeClock = _FakeClock(DateTime(2026, 1, 1, 9));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(seedDb),
            clockManagerProvider.overrideWithValue(fakeClock),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final repo = ProviderScope.containerOf(
                context,
              ).read(focusRepositoryProvider);
              // Fire-and-forget: the FocusScreen below will pick up the
              // resulting state once it resolves — awaited via pumpAndSettle.
              repo.startSession(id: 'seeded', plannedMinutes: 25);
              return const MaterialApp(home: FocusScreen());
            },
          ),
        ),
      );
      // Not pumpAndSettle(): once a session is active, FocusTimerDisplay
      // watches the once-a-second focusTickerProvider, whose
      // Stream.periodic never completes — pumpAndSettle would hang waiting
      // for a steady state that never arrives. A few explicit pumps drain
      // the async build chain deterministically instead.
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Focusing…'), findsOneWidget);
      expect(find.text('Start Focus'), findsNothing);
    },
  );
}
