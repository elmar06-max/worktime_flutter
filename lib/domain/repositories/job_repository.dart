import '../models/job.dart';

abstract class JobRepository {
  Future<List<Job>> getAll();
  Stream<List<Job>> watchAll();
  Future<Job> save(Job job);
  Future<Job> update(Job job);
  Future<void> delete(String id);
}
