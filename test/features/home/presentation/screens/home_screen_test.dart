import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/home/domain/models/home_section_config.dart';
import 'package:lifeos/features/home/presentation/providers/home_providers.dart';
import 'package:lifeos/features/home/presentation/providers/home_section_registry.dart';
import 'package:lifeos/features/home/presentation/screens/home_screen.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory fake so this test never touches platform channels for secure
/// storage — mirrors the fake already proven elsewhere in the test suite.
class _FakeSecureStorage extends FlutterSecureStorage {
  const _FakeSecureStorage(this._store);

  final Map<String, String> _store;

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _store[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {}
}

class _FakeClock implements ClockManager {
  _FakeClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpHome(
    WidgetTester tester, {
    HomeSectionsNotifier Function()? sectionsOverride,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    // recentNotesProvider/myListsProvider now thin-watch real feature
    // dashboard providers backed by AppDatabase — override with an
    // in-memory test database instead of touching getIt (never
    // initialized in this test process).
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider.overrideWithValue(
            PreferencesService(prefs),
          ),
          secureStorageServiceProvider.overrideWithValue(
            SecureStorageService(const _FakeSecureStorage({})),
          ),
          databaseProvider.overrideWithValue(db),
          clockManagerProvider.overrideWithValue(
            _FakeClock(DateTime(2026, 1, 1, 9)),
          ),
          if (sectionsOverride != null)
            homeSectionsProvider.overrideWith(sectionsOverride),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    // Let AsyncNotifiers resolve their mock futures.
    await tester.pump();
    await tester.pump();
  }

  testWidgets('pumps without error with default providers', (tester) async {
    await pumpHome(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text("Today's Timeline"), findsOneWidget);
  });

  testWidgets(
    'a hidden section (via homeSectionsProvider override) is omitted',
    (tester) async {
      final hiddenSections = kDefaultHomeSections
          .map(
            (s) => s.id == HomeSectionIds.timeline
                ? s.copyWith(visible: false)
                : s,
          )
          .toList();

      await pumpHome(
        tester,
        sectionsOverride: () => _FixedSectionsNotifier(hiddenSections),
      );

      expect(find.text("Today's Timeline"), findsNothing);
      expect(find.text('Quick Actions'), findsOneWidget);
    },
  );

  testWidgets(
    'a reordered list (via homeSectionsProvider override) changes render order',
    (tester) async {
      // Put Quick Actions after everything else.
      final reordered = [
        for (final s in kDefaultHomeSections)
          s.id == HomeSectionIds.quickActions ? s.copyWith(order: 99) : s,
      ];

      await pumpHome(
        tester,
        sectionsOverride: () => _FixedSectionsNotifier(reordered),
      );

      // "Tasks" is the first overview stat card's label — with Quick Actions
      // pushed to the end, the Overview section (still order 0) should now
      // render above Quick Actions.
      final tasksY = tester.getTopLeft(find.text('Tasks')).dy;
      final quickActionsY = tester.getTopLeft(find.text('Quick Actions')).dy;

      expect(quickActionsY, greaterThan(tasksY));
    },
  );
}

class _FixedSectionsNotifier extends HomeSectionsNotifier {
  _FixedSectionsNotifier(this._fixed);

  final List<HomeSectionMeta> _fixed;

  @override
  List<HomeSectionMeta> build() => _fixed;
}
