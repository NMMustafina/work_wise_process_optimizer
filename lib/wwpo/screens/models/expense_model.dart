import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 2)
class ExpenseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String category;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.category,
  });
}
