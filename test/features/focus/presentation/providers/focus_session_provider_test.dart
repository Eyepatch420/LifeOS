import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_dashboard_provider.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_session_provider.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);
  final DateTime _now;

  @override
  DateTime now() => _now;
}

void main() {
  ProviderContainer makeContainer() {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockManagerProvider.overrideWithValue(
          _FakeClock(DateTime(2026, 1, 1, 9)),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    return container;
  }

  test('retrieves a session by its id', () async {
    final container = makeContainer();
    final repository = container.read(focusRepositoryProvider);
    await repository.startSession(id: 'f1', plannedMinutes: 25);

    // `.autoDispose` providers are torn down as soon as their last listener
    // goes away — a bare `container.read(...future)` has no listener
    // keeping it alive between the read and the stream's first emission, so
    // it gets disposed mid-flight. A `container.listen` subscription (torn
    // down via addTearDown, matching this feature's other autoDispose
    // provider tests) keeps it alive for the read.
    final sub = container.listen(focusSessionByIdProvider('f1'), (_, _) {});
    addTearDown(sub.close);

    final session = await container.read(focusSessionByIdProvider('f1').future);
    expect(session?.id, 'f1');
    expect(session?.status, FocusSessionStatus.running);
  });

  test('resolves to null for an id with no matching session', () async {
    final container = makeContainer();
    final sub = container.listen(
      focusSessionByIdProvider('missing'),
      (_, _) {},
    );
    addTearDown(sub.close);

    final session = await container.read(
      focusSessionByIdProvider('missing').future,
    );
    expect(session, isNull);
  });
}
