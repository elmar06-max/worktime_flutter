import 'package:hive/hive.dart';

import '../../domain/models/work_entry.dart';

@HiveType(typeId: 0)
class WorkEntryHiveModel extends HiveObject {
  WorkEntryHiveModel({
    required this.id,
    required this.date,
    required this.jobId,
    required this.startTime,
    required this.endTime,
    required this.breakMinutes,
    required this.daytimeHours,
    required this.overtimeHours,
    required this.note,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String? jobId;

  @HiveField(3)
  DateTime startTime;

  @HiveField(4)
  DateTime endTime;

  @HiveField(5)
  int breakMinutes;

  @HiveField(6)
  double daytimeHours;

  @HiveField(7)
  double overtimeHours;

  @HiveField(8)
  String? note;

  WorkEntry toDomain() {
    return WorkEntry(
      id: id,
      date: date,
      jobId: jobId,
      startTime: startTime,
      endTime: endTime,
      breakMinutes: breakMinutes,
      daytimeHours: daytimeHours,
      overtimeHours: overtimeHours,
      note: note,
    );
  }

  static WorkEntryHiveModel fromDomain(WorkEntry entry) {
    return WorkEntryHiveModel(
      id: entry.id,
      date: entry.date,
      jobId: entry.jobId,
      startTime: entry.startTime,
      endTime: entry.endTime,
      breakMinutes: entry.breakMinutes,
      daytimeHours: entry.daytimeHours,
      overtimeHours: entry.overtimeHours,
      note: entry.note,
    );
  }
}
