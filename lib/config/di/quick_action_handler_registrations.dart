import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';

/// The single composition-layer seam mapping each `QuickAction.id` (see
/// `dashboard_card_data.dart`) to its navigation handler. Extracted out of
/// `home_section_registry.dart`'s hardcoded map so a future Settings
/// screen can hide entries (by filtering `quickActionsProvider`'s list)
/// without this map needing to change, and so adding a new quick action is
/// a registration here, not a `QuickActionsRow`/registry edit.
///
/// `'new_document'` intentionally has no entry — falls through
/// `QuickActionsRow`'s existing `?.call()` safe no-op guard. Documents is
/// its own future module; see docs/future_work.md.
Map<String, void Function(BuildContext context)> quickActionHandlers(Ref ref) {
  return {
    'new_note': (context) => context.pushNamed(RouteNames.newNote),
    'new_reminder': (context) => context.pushNamed(RouteNames.newReminder),
    'new_expense': (context) => context.pushNamed(RouteNames.newExpense),
    'new_habit': (context) => context.pushNamed(RouteNames.newHabit),
    'log_mood': (context) => context.pushNamed(RouteNames.logMood),
    'add_water': (context) => context.pushNamed(RouteNames.hydration),
    'log_sleep': (context) => context.pushNamed(RouteNames.sleep),
  };
}

final quickActionHandlersProvider =
    Provider<Map<String, void Function(BuildContext context)>>(
      quickActionHandlers,
    );
