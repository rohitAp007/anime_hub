// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_list_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyListItemAdapter extends TypeAdapter<MyListItem> {
  @override
  final int typeId = 0;

  @override
  MyListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyListItem(
      malId: fields[0] as int,
      title: fields[1] as String,
      posterUrl: fields[2] as String,
      score: fields[3] as double?,
      addedAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MyListItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.malId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterUrl)
      ..writeByte(3)
      ..write(obj.score)
      ..writeByte(4)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
