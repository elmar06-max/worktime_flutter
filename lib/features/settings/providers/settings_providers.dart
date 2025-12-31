import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../data/hive/hive_box_names.dart';
import '../../../data/hive/pay_settings_hive_model.dart';
import '../../../data/repositories/settings_repository_impl.dart';
import '../../../domain/models/pay_settings.dart';
import '../../../domain/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final box = Hive.box<PaySettingsHiveModel>(settingsBoxName);
  return SettingsRepositoryImpl(box);
});

final paySettingsProvider = StreamProvider<PaySettings?>((ref) {
  return ref.watch(settingsRepositoryProvider).watchPaySettings();
});
