// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitAdapter extends TypeAdapter<Unit> {
  @override
  final int typeId = 1;

  @override
  Unit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Unit(
      id: fields[0] as String,
      type: fields[1] as String,
      user_id: fields[2] as String,
      okay: fields[3] as bool,
      date: (fields[4] as Map).cast<String, int>(),
      title: fields[5] as String,
      content: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Unit obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.user_id)
      ..writeByte(3)
      ..write(obj.okay)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
