// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingAdapter extends TypeAdapter<Setting> {
  @override
  final typeId = 1;

  @override
  Setting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setting(darkMode: fields[0] as bool?);
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.darkMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Setting _$SettingFromJson(Map<String, dynamic> json) =>
    _Setting(darkMode: json['darkMode'] as bool?);

Map<String, dynamic> _$SettingToJson(_Setting instance) => <String, dynamic>{
  'darkMode': instance.darkMode,
};
