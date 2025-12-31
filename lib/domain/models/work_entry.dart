import 'package:uuid/uuid.dart';

class WorkEntry {
  WorkEntry({
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

  factory WorkEntry.newEntry({
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    String? jobId,
    int breakMinutes = 0,
    double daytimeHours = 0,
    double overtimeHours = 0,
    String? note,
  }) {
    return WorkEntry(
      id: const Uuid().v4(),
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

  final String id;
  final DateTime date;
  final String? jobId;
  final DateTime startTime;
  final DateTime endTime;
  final int breakMinutes;
  final double daytimeHours;
  final double overtimeHours;
  final String? note;

  WorkEntry copyWith({
    String? id,
    DateTime? date,
    String? jobId,
    DateTime? startTime,
    DateTime? endTime,
    int? breakMinutes,
    double? daytimeHours,
    double? overtimeHours,
    String? note,
  }) {
    return WorkEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      jobId: jobId ?? this.jobId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      daytimeHours: daytimeHours ?? this.daytimeHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      note: note ?? this.note,
    );
  }

  Duration get workedDuration =>
      endTime.difference(startTime) - Duration(minutes: breakMinutes);

  static bool isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
