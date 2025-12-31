import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../data/hive/hive_box_names.dart';
import '../../../data/hive/work_entry_hive_model.dart';
import '../../../data/repositories/work_entry_repository_impl.dart';
import '../../../domain/models/work_entry.dart';
import '../../../domain/repositories/work_entry_repository.dart';

final workEntryRepositoryProvider = Provider<WorkEntryRepository>((ref) {
  final box = Hive.box<WorkEntryHiveModel>(workEntriesBoxName);
  return WorkEntryRepositoryImpl(box);
});

final workEntriesProvider = StreamProvider<List<WorkEntry>>((ref) {
  final repository = ref.watch(workEntryRepositoryProvider);
  return repository.watchAll();
});
