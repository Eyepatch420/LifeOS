import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_dashboard_provider.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_search_contributor.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_search_contributor.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_search_contributor.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_dashboard_provider.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_search_contributor.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_search_contributor.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_search_contributor.dart';
import 'package:lifeos/features/search/domain/search_contributor.dart';

/// The single composition-layer seam allowed to import every Type A
/// feature's [SearchContributor] — `features/search` itself never does.
/// Add one line here when a feature gains a contributor; nothing inside
/// `features/search` changes.
List<SearchContributor> searchContributors(Ref ref) {
  return [
    NotesSearchContributor(ref.watch(notesRepositoryProvider)),
    ListsSearchContributor(ref.watch(listsRepositoryProvider)),
    RemindersSearchContributor(ref.watch(remindersRepositoryProvider)),
    HabitsSearchContributor(ref.watch(habitsRepositoryProvider)),
    CalendarSearchContributor(ref.watch(eventsRepositoryProvider)),
    const FocusSearchContributor(),
  ];
}
