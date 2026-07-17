import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/notes_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/notes/domain/entities/note.dart';
import 'package:lifeos/features/notes/domain/events/note_events.dart';

/// The single owner of Notes persistence — every mutation and query for
/// notes goes through here, wrapping [NotesDao] and mapping Drift rows to
/// the feature's own [Note] entity. No other feature imports this class or
/// [NotesDao] directly (see the Golden Rule).
class NotesRepository {
  NotesRepository(this._dao, this._eventBus);

  final NotesDao _dao;
  final EventBus _eventBus;

  Stream<List<Note>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  Future<Note?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  Future<void> create({
    required String id,
    required String title,
    required String body,
  }) async {
    final now = DateTime.now();
    await _dao.upsert(
      db.NotesCompanion.insert(
        id: id,
        title: title,
        body: body,
        createdAt: now,
        updatedAt: now,
      ),
    );
    _eventBus.emit(NoteCreated(noteId: id));
  }

  Future<void> update({
    required String id,
    required String title,
    required String body,
  }) {
    return _dao.updateFields(
      id,
      db.NotesCompanion(
        title: Value(title),
        body: Value(body),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setPinned(String id, bool isPinned) =>
      _dao.setPinned(id, isPinned);

  Future<void> delete(String id) => _dao.softDelete(id);

  Future<void> restore(String id) => _dao.restore(id);

  Note _toEntity(db.Note row) => Note(
    id: row.id,
    title: row.title,
    body: row.body,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    isPinned: row.isPinned,
  );
}
