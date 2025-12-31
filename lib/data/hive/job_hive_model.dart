import 'package:hive/hive.dart';

import '../../domain/models/job.dart';

@HiveType(typeId: 1)
class JobHiveModel extends HiveObject {
  JobHiveModel({required this.id, required this.name});

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  Job toDomain() => Job(id: id, name: name);

  static JobHiveModel fromDomain(Job job) {
    return JobHiveModel(id: job.id, name: job.name);
  }
}
