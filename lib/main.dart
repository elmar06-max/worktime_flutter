import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'data/hive/hive_box_names.dart';
       codex/plan-flutter-app-structure-and-state-management-2hoku7
import 'data/hive/job_adapter.dart';
import 'data/hive/job_hive_model.dart';

        main
import 'data/hive/work_entry_adapter.dart';
import 'data/hive/work_entry_hive_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
       codex/plan-flutter-app-structure-and-state-management-2hoku7
  await Hive.initFlutter();
  Hive.registerAdapter(WorkEntryHiveAdapter());
  Hive.registerAdapter(JobHiveAdapter());
  await Hive.openBox<JobHiveModel>(jobsBoxName);

        codex/plan-flutter-app-structure-and-state-management-zey9lz

        codex/plan-flutter-app-structure-and-state-management-u9eotl

        codex/plan-flutter-app-structure-and-state-management-orinbg

 codex/plan-flutter-app-structure-and-state-management-cpcdu8


     main
        main
        main
        main
  await Hive.initFlutter();
  Hive.registerAdapter(WorkEntryHiveAdapter());
        main
  await Hive.openBox<WorkEntryHiveModel>(workEntriesBoxName);

  runApp(
    const ProviderScope(
      child: WorkTimeApp(),
    ),
  );
}
