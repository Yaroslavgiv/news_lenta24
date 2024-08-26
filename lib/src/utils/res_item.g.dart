// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'res_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RssItemAdapter extends TypeAdapter<RssItem> {
  @override
  final int typeId = 0;

  @override
  RssItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RssItem(
      title: fields[0] as String,
      description: fields[1] as String,
      link: fields[2] as String,
      author: fields[3] as String,
      enclosure: fields[4] as Enclosure,
    );
  }

  @override
  void write(BinaryWriter writer, RssItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.author)
      ..writeByte(4)
      ..write(obj.enclosure);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RssItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EnclosureAdapter extends TypeAdapter<Enclosure> {
  @override
  final int typeId = 1;

  @override
  Enclosure read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Enclosure(
      url: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Enclosure obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnclosureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
