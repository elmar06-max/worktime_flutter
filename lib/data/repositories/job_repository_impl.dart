import 'package:hive/hive.dart';

import '../../domain/models/job.dart';
import '../../domain/repositories/job_repository.dart';
import '../hive/job_hive_model.dart';

class JobRepositoryImpl implements JobRepository {
  JobRepositoryImpl(this._box);

  final Box<JobHiveModel> _box;

  @override
  Future<List<Job>> getAll() async {
    return _box.values.map((job) => job.toDomain()).toList();
  }

  @override
  Stream<List<Job>> watchAll() async* {
    yield await getAll();
    yield* _box.watch().map(
      (_) => _box.values.map((job) => job.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Job> save(Job job) async {
    final model = JobHiveModel.fromDomain(job);
    await _box.put(model.id, model);
    return model.toDomain();
  }

  @override
  Future<Job> update(Job job) async {
    if (!_box.containsKey(job.id)) {
      throw StateError('Cannot update missing Job with id: ${job.id}');
    }
    final model = JobHiveModel.fromDomain(job);
    await _box.put(model.id, model);
    return model.toDomain();
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
