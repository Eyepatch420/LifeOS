import 'package:flutter/material.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';

/// Static mock data for the Home dashboard — Module 2 has no real
/// reminders/notes/expenses wired up yet (those are future modules), so
/// this is hardcoded rather than served from a repository. Each const is
/// the `build()` body of its section's `AsyncNotifier` (see
/// `home_providers.dart`) — swapping in a real repository call later only
/// touches that one `build()` method, never these consts' consumers.
const List<OverviewStat> kOverviewStats = [
  OverviewStat(
    icon: Icons.checklist_rounded,
    label: 'Tasks',
    value: '4',
    subtitle: '2 done · 2 pending',
    progress: 0.5,
  ),
  OverviewStat(
    icon: Icons.local_fire_department_rounded,
    label: 'Habits',
    value: '3',
    subtitle: '2 completed today',
    progress: 0.66,
  ),
  OverviewStat(
    icon: Icons.timer_outlined,
    label: 'Focus',
    value: '2h 15m',
    subtitle: 'Today',
    progress: 0.7,
  ),
  OverviewStat(
    icon: Icons.mood_rounded,
    label: 'Mood',
    value: 'Good',
    subtitle: 'Feeling steady',
    progress: 0.8,
  ),
];

const List<QuickAction> kQuickActions = [
  QuickAction(id: 'new_note', icon: Icons.note_add_outlined, label: 'New Note'),
  QuickAction(
    id: 'new_reminder',
    icon: Icons.notifications_active_outlined,
    label: 'New Reminder',
  ),
  QuickAction(
    id: 'new_expense',
    icon: Icons.currency_rupee,
    label: 'New Expense',
  ),
  QuickAction(
    id: 'new_habit',
    icon: Icons.local_fire_department_outlined,
    label: 'New Habit',
  ),
  QuickAction(
    id: 'new_document',
    icon: Icons.document_scanner_outlined,
    label: 'New Document',
  ),
];

const List<UpNextItem> kUpNext = [
  UpNextItem(
    id: 'up-next-medicine',
    icon: Icons.medication_outlined,
    title: 'Metformin 500mg',
    subtitle: '2:00 PM · In 45 min',
    isUrgent: false,
  ),
  UpNextItem(
    id: 'up-next-standup',
    icon: Icons.groups_outlined,
    title: 'Team Standup',
    subtitle: '10:30 AM · In 15 min',
    isUrgent: true,
  ),
  UpNextItem(
    id: 'up-next-walk',
    icon: Icons.directions_walk,
    title: 'Evening Walk',
    subtitle: '6:30 PM',
    isUrgent: false,
  ),
  UpNextItem(
    id: 'up-next-electricity-bill',
    icon: Icons.receipt_long_outlined,
    title: 'Electricity Bill',
    subtitle: 'Due Tomorrow',
    isUrgent: true,
  ),
];

const List<HabitStreak> kHabitStreaks = [
  HabitStreak(
    icon: Icons.directions_walk,
    title: 'Morning Walk',
    streakDays: 12,
    last7Days: [true, true, true, true, true, true, false],
  ),
  HabitStreak(
    icon: Icons.menu_book_outlined,
    title: 'Read 20 Pages',
    streakDays: 7,
    last7Days: [true, true, true, true, true, true, false],
  ),
  HabitStreak(
    icon: Icons.water_drop_outlined,
    title: 'Drink 2L Water',
    streakDays: 5,
    last7Days: [true, true, true, true, true, false, false],
  ),
];

const List<TimelineStep> kTimeline = [
  TimelineStep(
    id: 'timeline-medicine',
    icon: Icons.medication_outlined,
    label: 'Medicine',
    time: '2:00 PM',
    dotColor: Color(0xFF2F6FED),
  ),
  TimelineStep(
    id: 'timeline-lunch',
    icon: Icons.lunch_dining_outlined,
    label: 'Lunch',
    time: '12:30 PM',
    dotColor: Color(0xFFEF8A2C),
  ),
  TimelineStep(
    id: 'timeline-meeting',
    icon: Icons.work_outline,
    label: 'Meeting',
    time: '3:00 PM',
    dotColor: Color(0xFF2F6FED),
  ),
  TimelineStep(
    id: 'timeline-walk',
    icon: Icons.directions_walk,
    label: 'Walk',
    time: '6:30 PM',
    dotColor: Color(0xFF2FAE6A),
  ),
  TimelineStep(
    id: 'timeline-read',
    icon: Icons.menu_book_outlined,
    label: 'Read',
    time: '9:00 PM',
    dotColor: Color(0xFF7A5CC9),
  ),
];

const List<NoteSummary> kRecentNotes = [
  NoteSummary(
    icon: Icons.list_alt_outlined,
    title: 'Grocery List',
    preview: 'Milk, Eggs, Bread, Fruits...',
    timestamp: 'Today, 8:30 AM',
    isPinned: true,
  ),
  NoteSummary(
    icon: Icons.lightbulb_outline,
    title: 'Project Ideas',
    preview: 'New features for LifeOS...',
    timestamp: 'Yesterday, 11:15 PM',
    isPinned: false,
  ),
];

const List<ListSummary> kMyLists = [
  ListSummary(
    icon: Icons.shopping_basket_outlined,
    title: 'Shopping',
    subtitle: '5 items left',
    progress: 0.6,
  ),
  ListSummary(
    icon: Icons.checklist_rtl_outlined,
    title: 'Weekend Chores',
    subtitle: '3 of 6 done',
    progress: 0.5,
  ),
];

const String kMotivationalMessage =
    'Small progress today, big change tomorrow.';
