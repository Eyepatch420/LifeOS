import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_dashboard_provider.dart';

/// A single Focus session by id, live from persistence — backs the Session
/// Details screen so it always reflects the authoritative record and keeps
/// working after process recreation/deep navigation (the id is all that's
/// passed through the route, never a mutable [FocusSession] object; see
/// `app_router.dart`'s `focusSessionDetail` route).
final focusSessionByIdProvider = StreamProvider.autoDispose
    .family<FocusSession?, String>((ref, id) {
      final repository = ref.watch(focusRepositoryProvider);
      return repository.watchById(id);
    });
