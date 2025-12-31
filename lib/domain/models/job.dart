import 'package:uuid/uuid.dart';

class Job {
  Job({
    required this.id,
    required this.name,
  });

  factory Job.create(String name) {
    return Job(
      id: const Uuid().v4(),
      name: name,
    );
  }

  final String id;
  final String name;

  Job copyWith({
    String? id,
    String? name,
  }) {
    return Job(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
