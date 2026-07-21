import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/health/presentation/widgets/health_workspace_scaffold.dart';

/// Which tab of the Mood/Medications Health workspace is currently shown —
/// pure local UI state, mirrors `PlanningWorkspaceSectionNotifier` exactly.
/// Deliberately NOT `.autoDispose` for the same reason that provider isn't:
/// [HealthWorkspaceScaffold] stays mounted for the whole `/health` branch
/// lifetime, so losing this on a stray rebuild would silently reset the
/// user back to the Mood tab.
class HealthWorkspaceSectionNotifier extends Notifier<HealthWorkspaceSection> {
  @override
  HealthWorkspaceSection build() => HealthWorkspaceSection.mood;

  void select(HealthWorkspaceSection section) => state = section;
}

final healthWorkspaceSectionProvider =
    NotifierProvider<HealthWorkspaceSectionNotifier, HealthWorkspaceSection>(
      HealthWorkspaceSectionNotifier.new,
    );
