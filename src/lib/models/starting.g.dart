// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StartingAdapter extends TypeAdapter<Starting> {
  @override
  final int typeId = 4;

  @override
  Starting read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Starting.defence;
      case 1:
        return Starting.offense;
      default:
        return Starting.defence;
    }
  }

  @override
  void write(BinaryWriter writer, Starting obj) {
    switch (obj) {
      case Starting.defence:
        writer.writeByte(0);
        break;
      case Starting.offense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
