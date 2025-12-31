import 'dart:async';

import 'package:hive/hive.dart';

import '../../domain/models/work_entry.dart';
import '../../domain/repositories/work_entry_repository.dart';
import '../hive/work_entry_hive_model.dart';

class WorkEntryRepositoryImpl implements WorkEntryRepository {
  WorkEntryRepositoryImpl(this._box);

  final Box<WorkEntryHiveModel> _box;

  @override
  Future<List<WorkEntry>> getAll() async {
    return _box.values.map((model) => model.toDomain()).toList();
  }

  @override
  Future<List<WorkEntry>> getByDate(DateTime date) async {
    return _box.values
        .where((entry) => WorkEntry.isSameDay(entry.date, date))
        .map((model) => model.toDomain())
        .toList();
  }

  @override
  Future<WorkEntry> save(WorkEntry entry) async {
    final hiveModel = WorkEntryHiveModel.fromDomain(entry);
    await _box.put(hiveModel.id, hiveModel);
    return hiveModel.toDomain();
  }

  @override
  Future<WorkEntry> update(WorkEntry entry) async {
    if (!_box.containsKey(entry.id)) {
      throw StateError('Cannot update missing WorkEntry with id: ${entry.id}');
    }
    final hiveModel = WorkEntryHiveModel.fromDomain(entry);
    await _box.put(hiveModel.id, hiveModel);
    return hiveModel.toDomain();
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Stream<List<WorkEntry>> watchAll() async* {
    yield await getAll();
    yield* _box.watch().map((_) => _box.values
        .map((entry) => entry.toDomain())
        .toList(growable: false));
  }
}
