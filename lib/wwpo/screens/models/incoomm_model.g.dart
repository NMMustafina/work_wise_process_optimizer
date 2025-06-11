// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoomm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncoommModelAdapter extends TypeAdapter<IncoommModel> {
  @override
  final int typeId = 0;

  @override
  IncoommModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncoommModel(
      id: fields[0] as String,
      amounntt: fields[1] as double,
      daatee: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, IncoommModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amounntt)
      ..writeByte(2)
      ..write(obj.daatee);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncoommModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
