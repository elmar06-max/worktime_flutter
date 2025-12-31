import 'package:hive/hive.dart';

import 'work_entry_hive_model.dart';

class WorkEntryHiveAdapter extends TypeAdapter<WorkEntryHiveModel> {
  @override
  final int typeId = 0;

  @override
  WorkEntryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return WorkEntryHiveModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      jobId: fields[2] as String?,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime,
      breakMinutes: fields[5] as int,
      daytimeHours: fields[6] as double,
      overtimeHours: fields[7] as double,
      note: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkEntryHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.jobId)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.breakMinutes)
      ..writeByte(6)
      ..write(obj.daytimeHours)
      ..writeByte(7)
      ..write(obj.overtimeHours)
      ..writeByte(8)
      ..write(obj.note);
  }
}
