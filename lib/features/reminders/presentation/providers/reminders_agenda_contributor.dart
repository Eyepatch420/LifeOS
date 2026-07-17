import 'package:flutter/material.dart';
import 'package:lifeos/core/agenda/agenda_contributor.dart';
import 'package:lifeos/core/agenda/agenda_entry.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';

/// Reminders' contribution to the shared cross-feature Agenda (Home's Up
/// Next/Timeline). Registered at
/// `config/di/agenda_contributor_registrations.dart`, not imported by
/// `core/agenda/` or `features/home/` directly.
class RemindersAgendaContributor implements AgendaContributor {
  const RemindersAgendaContributor(this._repository);

  final RemindersRepository _repository;

  @override
  Stream<List<AgendaEntry>> contributions() {
    return _repository.watchAll().map(
      (reminders) => [
        for (final reminder in reminders.where((r) => !r.isCompleted))
          AgendaEntry(
            id: reminder.id,
            sourceModule: 'reminders',
            sourceId: reminder.id,
            icon: Icons.medication_outlined,
            title: reminder.title,
            time: reminder.dueAt,
            dotColor: reminder.isUrgent ? Colors.red : Colors.blue,
            isUrgent: reminder.isUrgent,
          ),
      ],
    );
  }

  @override
  Future<void> dismiss(String id) => _repository.setCompleted(id, true);
}
