import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/constants/pref_keys.dart';
import 'package:lifeos/features/focus/presentation/widgets/focus_dnd_toggle.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<List<MethodCall>> pump(
    WidgetTester tester, {
    bool? isPolicyAccessGranted,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = PreferencesService(await SharedPreferences.getInstance());
    final calls = <MethodCall>[];

    const channel = MethodChannel('com.lifeos/dnd');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'isPolicyAccessGranted') {
            return isPolicyAccessGranted ?? true;
          }
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [preferencesServiceProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: Scaffold(body: FocusDndToggle())),
      ),
    );
    await tester.pumpAndSettle();
    return calls;
  }

  testWidgets('starts off by default', (tester) async {
    await pump(tester);

    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.value, isFalse);
  });

  testWidgets(
    'turning it on persists the opt-in and, when policy access is already '
    'granted, does not open settings',
    (tester) async {
      final calls = await pump(tester, isPolicyAccessGranted: true);

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(tile.value, isTrue);
      expect(
        calls.map((c) => c.method),
        isNot(contains('openPolicyAccessSettings')),
      );
    },
  );

  testWidgets(
    'turning it on when policy access is not granted opens the settings '
    'screen',
    (tester) async {
      final calls = await pump(tester, isPolicyAccessGranted: false);

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(calls.map((c) => c.method), contains('openPolicyAccessSettings'));
    },
  );

  testWidgets('reflects a previously persisted opt-in on rebuild', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({PrefKeys.focusDndOptIn: true});
    final prefs = PreferencesService(await SharedPreferences.getInstance());
    const channel = MethodChannel('com.lifeos/dnd');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => true);
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [preferencesServiceProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: Scaffold(body: FocusDndToggle())),
      ),
    );
    await tester.pumpAndSettle();

    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.value, isTrue);
  });
}
