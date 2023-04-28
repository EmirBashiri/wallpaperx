// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallpaperEntityAdapter extends TypeAdapter<WallpaperEntity> {
  @override
  final int typeId = 1;

  @override
  WallpaperEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallpaperEntity(
      id: fields[0] as String,
      coverLink: fields[1] as String,
      viewLink: fields[2] as String,
      downloadLink: fields[3] as String,
      photographerProfileLink: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WallpaperEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coverLink)
      ..writeByte(2)
      ..write(obj.viewLink)
      ..writeByte(3)
      ..write(obj.downloadLink)
      ..writeByte(4)
      ..write(obj.photographerProfileLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallpaperEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
