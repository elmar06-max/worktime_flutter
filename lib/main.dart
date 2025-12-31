import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'data/hive/hive_box_names.dart';
import 'data/hive/job_adapter.dart';
import 'data/hive/job_hive_model.dart';
import 'data/hive/pay_settings_adapter.dart';
import 'data/hive/pay_settings_hive_model.dart';
import 'data/hive/work_entry_adapter.dart';
import 'data/hive/work_entry_hive_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WorkEntryHiveAdapter());
  Hive.registerAdapter(JobHiveAdapter());
  Hive.registerAdapter(PaySettingsHiveAdapter());
  await Hive.openBox<JobHiveModel>(jobsBoxName);
  await Hive.openBox<PaySettingsHiveModel>(settingsBoxName);
  await Hive.openBox<WorkEntryHiveModel>(workEntriesBoxName);

  runApp(
    const ProviderScope(
      child: WorkTimeApp(),
    ),
  );
}
