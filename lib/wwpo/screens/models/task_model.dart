import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 4)
class TaskModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String priority; // 'Low', 'Medium', 'High'

  @HiveField(5)
  final bool reminder;

  @HiveField(6)
  late final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.date,
    required this.priority,
    this.description,
    this.reminder = false,
    this.isCompleted = false,
  });
}
