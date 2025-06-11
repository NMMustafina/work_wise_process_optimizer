// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalModelAdapter extends TypeAdapter<GoalModel> {
  @override
  final int typeId = 7;

  @override
  GoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalModel(
      id: fields[0] as String,
      title: fields[1] as String,
      deadline: fields[2] as DateTime?,
      status: fields[3] as GoalStatus,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GoalModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.deadline)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalStatusAdapter extends TypeAdapter<GoalStatus> {
  @override
  final int typeId = 6;

  @override
  GoalStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalStatus.notStarted;
      case 1:
        return GoalStatus.inProgress;
      case 2:
        return GoalStatus.completed;
      default:
        return GoalStatus.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, GoalStatus obj) {
    switch (obj) {
      case GoalStatus.notStarted:
        writer.writeByte(0);
        break;
      case GoalStatus.inProgress:
        writer.writeByte(1);
        break;
      case GoalStatus.completed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
