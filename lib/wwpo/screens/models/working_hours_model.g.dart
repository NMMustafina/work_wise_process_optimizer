// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_hours_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkingHoursModelAdapter extends TypeAdapter<WorkingHoursModel> {
  @override
  final int typeId = 3;

  @override
  WorkingHoursModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkingHoursModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      hours: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WorkingHoursModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.hours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkingHoursModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
