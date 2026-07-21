import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart' hide MoodEntry;
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/mood/domain/entities/mood_entry.dart';
import 'package:lifeos/features/mood/presentation/providers/mood_dashboard_provider.dart';
import 'package:lifeos/features/mood/presentation/screens/log_mood_screen.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

void main() {
  Future<ProviderContainer> pump(WidgetTester tester) async {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    late ProviderContainer container;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/log-mood',
          builder: (context, state) => const LogMoodScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockManagerProvider.overrideWithValue(
            _FakeClock(DateTime(2026, 1, 1, 9)),
          ),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();
    router.push('/log-mood');
    await tester.pumpAndSettle();
    return container;
  }

  Future<List<MoodEntry>> currentEntries(ProviderContainer container) async {
    final sub = container.listen(_moodListProvider, (_, _) {});
    await container.read(_moodListProvider.future);
    final value = container.read(_moodListProvider).value!;
    sub.close();
    return value;
  }

  testWidgets('renders a mood level picker, note field, and Save CTA', (
    tester,
  ) async {
    await pump(tester);

    expect(find.textContaining('Good'), findsOneWidget);
    expect(find.textContaining('Great'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Note (optional)'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('no level selected shows a validation error and does not save', (
    tester,
  ) async {
    final container = await pump(tester);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Choose how you\'re feeling'), findsOneWidget);
    expect(await currentEntries(container), isEmpty);
  });

  testWidgets('saving a selected level persists it and pops', (tester) async {
    final container = await pump(tester);

    await tester.tap(find.textContaining('Great'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final entries = await currentEntries(container);
    expect(entries, hasLength(1));
    expect(entries.single.level.name, 'great');
  });

  testWidgets('saving with a note persists it too', (tester) async {
    final container = await pump(tester);

    await tester.tap(find.textContaining('Good'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Note (optional)'),
      'Feeling productive',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final entries = await currentEntries(container);
    expect(entries.single.note, 'Feeling productive');
  });
}

final _moodListProvider = StreamProvider.autoDispose<List<MoodEntry>>((ref) {
  return ref.watch(moodRepositoryProvider).watchAll();
});
