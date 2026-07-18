import 'package:flutter/material.dart';
import 'package:lifeos/core/planner/planner_item.dart';

/// The data-driven semantic state a [PlannerItem] maps to for icon/accent
/// purposes — derived purely from existing fields (`isCompleted`,
/// `isUrgent`, `isRecurring`), never a fabricated category (see Phase 5
/// plan's explicit ban on inventing Medicine/Meeting/Bill-style
/// categories). Completion takes precedence over urgency/recurrence: a
/// completed urgent reminder still reads as "completed" first.
enum PlannerItemVisualState { completed, urgent, recurring, normal }

PlannerItemVisualState visualStateFor(PlannerItem item) {
  if (item.isCompleted) return PlannerItemVisualState.completed;
  if (item.isUrgent) return PlannerItemVisualState.urgent;
  if (item.isRecurring) return PlannerItemVisualState.recurring;
  return PlannerItemVisualState.normal;
}

IconData iconForVisualState(PlannerItemVisualState state) {
  return switch (state) {
    PlannerItemVisualState.completed => Icons.check_circle,
    PlannerItemVisualState.urgent => Icons.priority_high_rounded,
    PlannerItemVisualState.recurring => Icons.repeat,
    PlannerItemVisualState.normal => Icons.notifications_active_outlined,
  };
}
