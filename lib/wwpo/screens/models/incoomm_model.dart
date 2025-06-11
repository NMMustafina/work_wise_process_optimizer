import 'package:hive/hive.dart';

part 'incoomm_model.g.dart';

@HiveType(typeId: 0)
class IncoommModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amounntt;

  @HiveField(2)
  final DateTime daatee;

  IncoommModel({
    required this.id,
    required this.amounntt,
    required this.daatee,
  });
}
