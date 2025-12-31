import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../data/hive/hive_box_names.dart';
import '../../../data/hive/job_hive_model.dart';
import '../../../data/repositories/job_repository_impl.dart';
import '../../../domain/models/job.dart';
import '../../../domain/repositories/job_repository.dart';

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final box = Hive.box<JobHiveModel>(jobsBoxName);
  return JobRepositoryImpl(box);
});

final jobsProvider = StreamProvider<List<Job>>((ref) {
  return ref.watch(jobRepositoryProvider).watchAll();
});
