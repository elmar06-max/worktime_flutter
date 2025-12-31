import 'package:hive/hive.dart';

import 'pay_settings_hive_model.dart';

class PaySettingsHiveAdapter extends TypeAdapter<PaySettingsHiveModel> {
  @override
  final int typeId = 2;

  @override
  PaySettingsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaySettingsHiveModel(
      hourlyRate: fields[0] as double,
      overtimeMultiplier: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PaySettingsHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hourlyRate)
      ..writeByte(1)
      ..write(obj.overtimeMultiplier);
  }
}
