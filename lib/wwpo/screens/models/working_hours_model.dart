import 'package:hive/hive.dart';

part 'working_hours_model.g.dart';

@HiveType(typeId: 3)
class WorkingHoursModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double hours;

  WorkingHoursModel({
    required this.id,
    required this.date,
    required this.hours,
  });
}
