import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/calendar/domain/entities/event.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_dashboard_provider.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_selected_date_provider.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planning_workspace_scaffold.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/planning/planner_date_strip.dart';
import 'package:lifeos/shared/widgets/planning/planner_header.dart';
import 'package:lifeos/theme/theme_providers.dart';

/// The `/reminders/calendar` workspace root — a real, Drift-backed Calendar
/// dashboard hosted by the same [PlanningWorkspaceScaffold] as
/// `RemindersDashboardScreen`/`PlannerScreen`/`HabitsDashboardScreen`,
/// replacing the Phase 5/6 non-navigating nav placeholder.
///
/// Calendar's selected date ([calendarSelectedDateProvider]) is
/// deliberately independent from Planner's ([plannerSelectedDateProvider])
/// — see that provider's doc comment.
class CalendarDashboardScreen extends ConsumerWidget {
  const CalendarDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(calendarSelectedDateProvider);
    final dateNotifier = ref.read(calendarSelectedDateProvider.notifier);
    final theme = ref.watch(activeWorkspaceThemeProvider);
    final eventsAsync = ref.watch(_selectedDayEventsProvider(selectedDate));

    return PlanningWorkspaceScaffold(
      activeSection: PlanningWorkspaceSection.calendar,
      content: StaggeredEntrance(
        children: [
          PlannerHeader(
            selectedDate: selectedDate,
            onPreviousDay: dateNotifier.previousDay,
            onNextDay: dateNotifier.nextDay,
            onToday: dateNotifier.resetToToday,
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: PlannerDateStrip(
              selectedDate: selectedDate,
              onDateSelected: dateNotifier.selectDate,
              theme: theme,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: eventsAsync.when(
              data: (events) => _CalendarDayContent(
                events: events,
                selectedDate: selectedDate,
              ),
              loading: () => const _CalendarLoading(),
              error: (error, stack) => _CalendarError(
                onRetry: () =>
                    ref.invalidate(_selectedDayEventsProvider(selectedDate)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final _selectedDayEventsProvider = StreamProvider.autoDispose
    .family<List<Event>, DateTime>((ref, date) {
      return ref.watch(eventsRepositoryProvider).watchForDate(date);
    });

class _CalendarDayContent extends StatelessWidget {
  const _CalendarDayContent({required this.events, required this.selectedDate});

  final List<Event> events;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final allDay = events.where((e) => e.isAllDay).toList();
    final timed = events.where((e) => !e.isAllDay).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    if (events.isEmpty) {
      return EmptyState(
        icon: Icons.event_available_outlined,
        message: 'No events on this day',
        ctaLabel: 'Add Event',
        onCtaTap: () =>
            context.pushNamed(RouteNames.newEvent, extra: selectedDate),
      );
    }

    void openDetail(String eventId) {
      context.pushNamed(
        RouteNames.eventDetail,
        pathParameters: {'eventId': eventId},
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (allDay.isNotEmpty) ...[
          Text(
            'All Day',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final event in allDay)
            _EventCard(event: event, onTap: () => openDetail(event.id)),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (timed.isNotEmpty) ...[
          Text(
            'Schedule',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final event in timed)
            _EventCard(event: event, onTap: () => openDetail(event.id)),
        ],
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: TextButton.icon(
            onPressed: () =>
                context.pushNamed(RouteNames.newEvent, extra: selectedDate),
            icon: const Icon(Icons.add),
            label: const Text('Add Event'),
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});

  final Event event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Semantics(
        button: true,
        label: event.isAllDay
            ? '${event.title}, all day'
            : '${event.title}, ${DateFormat('h:mm a').format(event.startAt)}',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: SectionCard(
            child: Row(
              children: [
                Icon(Icons.event_outlined, color: context.colorScheme.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  event.isAllDay
                      ? 'All day'
                      : DateFormat('h:mm a').format(event.startAt),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarLoading extends StatelessWidget {
  const _CalendarLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _CalendarError extends StatelessWidget {
  const _CalendarError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: EmptyState(
        icon: Icons.error_outline,
        message: "Couldn't load your calendar",
        ctaLabel: 'Retry',
        onCtaTap: onRetry,
      ),
    );
  }
}
