import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'searchable_entity.freezed.dart';

/// One indexable, navigable thing in the app. Deliberately general-purpose
/// rather than Search-specific (`SearchResult`) — future modules
/// (Reminders/Health/Finance/Documents/Settings) can register their own
/// real content into the same index later without a rename/refactor of the
/// Search feature itself. See `search_providers.dart`.
@freezed
abstract class SearchableEntity with _$SearchableEntity {
  const factory SearchableEntity({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required SearchableEntityCategory category,
    required String routeName,
    Map<String, String>? pathParameters,
  }) = _SearchableEntity;
}

/// What kind of thing a [SearchableEntity] represents — drives how
/// `SearchScreen` navigates on tap (branch switch via `goNamed` for the 5
/// tab categories, or `pop()` back to Home for categories with no detail
/// screen yet).
enum SearchableEntityCategory {
  note,
  list,
  upNext,
  reminder,
  home,
  remindersTab,
  health,
  finance,
  documents,
  settings,
}
