import 'package:hive/hive.dart';

import '../../domain/models/pay_settings.dart';

@HiveType(typeId: 2)
class PaySettingsHiveModel extends HiveObject {
  PaySettingsHiveModel({
    required this.hourlyRate,
    required this.overtimeMultiplier,
  });

  @HiveField(0)
  double hourlyRate;

  @HiveField(1)
  double overtimeMultiplier;

  PaySettings toDomain() {
    return PaySettings(
      hourlyRate: hourlyRate,
      overtimeMultiplier: overtimeMultiplier,
    );
  }

  static PaySettingsHiveModel fromDomain(PaySettings settings) {
    return PaySettingsHiveModel(
      hourlyRate: settings.hourlyRate,
      overtimeMultiplier: settings.overtimeMultiplier,
    );
  }
}
