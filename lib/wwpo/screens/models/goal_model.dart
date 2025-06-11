import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 6)
enum GoalStatus {
  @HiveField(0)
  notStarted,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  completed,
}

@HiveType(typeId: 7)
class GoalModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime? deadline;

  @HiveField(3)
  GoalStatus status;

  @HiveField(4)
  final DateTime createdAt;

  GoalModel({
    required this.id,
    required this.title,
    this.deadline,
    this.status = GoalStatus.notStarted,
    required this.createdAt,
  });
}
