import '../models/work_entry.dart';

abstract class WorkEntryRepository {
  Future<List<WorkEntry>> getAll();

  Future<List<WorkEntry>> getByDate(DateTime date);

  Future<WorkEntry> save(WorkEntry entry);

  Future<WorkEntry> update(WorkEntry entry);

  Future<void> delete(String id);

  Stream<List<WorkEntry>> watchAll();
}
