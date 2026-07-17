import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/expenses_table.dart';

part 'expenses_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpensesDao extends DatabaseAccessor<AppDatabase>
    with _$ExpensesDaoMixin {
  ExpensesDao(super.db);

  Stream<List<Expense>> watchAll() {
    return (select(expenses)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
        .watch();
  }

  Future<Expense?> getById(String id) {
    return (select(
      expenses,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  Future<void> upsert(ExpensesCompanion entry) =>
      into(expenses).insertOnConflictUpdate(entry);

  Future<void> softDelete(String id) {
    return (update(expenses)..where((t) => t.id.equals(id))).write(
      ExpensesCompanion(deletedAt: Value(DateTime.now())),
    );
  }

  Future<void> restore(String id) {
    return (update(expenses)..where((t) => t.id.equals(id))).write(
      const ExpensesCompanion(deletedAt: Value(null)),
    );
  }
}
