// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreAdapter extends TypeAdapter<Score> {
  @override
  final int typeId = 3;

  @override
  Score read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Score(
      fields[0] as int,
      fields[6] as DateTime,
      fields[7] as int,
      fields[8] as int,
      fields[9] as Starting,
      fields[10] as Team,
      fields[11] as Game,
    );
  }

  @override
  void write(BinaryWriter writer, Score obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.turnOver)
      ..writeByte(8)
      ..write(obj.block)
      ..writeByte(9)
      ..write(obj.starting)
      ..writeByte(10)
      ..write(obj.team)
      ..writeByte(11)
      ..write(obj.game);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
