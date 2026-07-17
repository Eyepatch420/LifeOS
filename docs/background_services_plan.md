# Background Services Plan

Governs the `core/services/` scaffolds (`BackgroundService`, `ForegroundTimer`, `SyncManager`, `NotificationScheduler`) and how real notification scheduling (Reminders, Module 4 Phase 3) fits into them. Referenced by doc comments in those files since Module 4 Phase 1, written now that `NotificationScheduler` has its first real implementation.

## The flow

```
Feature Repository (e.g. RemindersRepository)
    │  emits a DomainEvent (ReminderCreated/ReminderUpdated/ReminderCompleted/ReminderDeleted)
    ▼
EventBus
    ▼
NotificationEngine (core/notifications/) — the one subscriber
    │  maps the event via a registered NotificationContributor to a
    │  ScheduleNotification/CancelNotification intent
    ▼
NotificationScheduler (core/services/)
    ▼
LocalNotificationScheduler → flutter_local_notifications (Android-first)
```

A repository never calls `NotificationScheduler`, `flutter_local_notifications`, or any platform channel directly — only `EventBus.emit(...)`. This is Architecture Constraint 5.

## What's implemented (Module 4 Phase 3 / this pass)

- `LocalNotificationScheduler` (`core/services/notification_scheduler.dart`) — Android-first, `flutter_local_notifications` + `timezone`, `zonedSchedule` with `AndroidScheduleMode.exactAllowWhileIdle`.
- Stable string→int id mapping (`_stableIntId`) so the app's own string ids never need a second id tracked anywhere.
- `NotificationEngine` (`core/notifications/notification_engine.dart`) — subscribes to `EventBus`, dispatches to registered `NotificationContributor`s, drives the scheduler, and persists an in-app feed row (`NotificationsDao`) for schedule intents.
- Reminders (the first and only contributor in this pass) reschedules on `ReminderUpdated`, cancels on `ReminderCompleted`/`ReminderDeleted`, schedules fresh on `ReminderCreated`.

## What's deferred (explicitly, not silently)

- **Reschedule-on-reboot**: Android clears `AlarmManager`-backed exact alarms on device reboot. A full guarantee needs a boot-completed `BroadcastReceiver` (native Android, outside `flutter_local_notifications`' own scope) that re-reads all pending reminders from `RemindersDao` and re-calls `NotificationScheduler.scheduleAt` for each. Not implemented in this pass — flagged here as the immediate follow-up item once Reminders ships. Until then, a reminder scheduled before a device reboot will not fire after that reboot; the in-app Up Next/Timeline views remain correct regardless (they read the DB directly, not the OS notification state).
- **iOS scheduling**: `NotificationScheduler`'s interface is platform-agnostic; `LocalNotificationScheduler`'s `initialize()` only sets up the Android channel. An iOS implementation is a later, separate pass behind the same interface — no redesign needed.
- **Recurring reminder instance materialization**: `Reminder.recurrence` (Phase A) stores the rule, but turning a recurring rule into concrete future scheduled instances (beyond the single next occurrence) is out of scope for this pass — the model supports it without a future migration, but the materialization logic isn't built yet.
- **`BackgroundService`/`ForegroundTimer`**: stay no-op scaffolds. Reminders' notification scheduling doesn't need either — `flutter_local_notifications`' own `AlarmManager`-backed scheduling handles "fire while the app isn't running" without a foreground service. These two scaffolds remain reserved for Focus's timer (Phase 4-equivalent) and any future periodic sync.
