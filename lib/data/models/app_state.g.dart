// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppStateAdapter extends TypeAdapter<AppState> {
  @override
  final typeId = 0;

  @override
  AppState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppState(
      accessToken: fields[0] as String?,
      tokenCreatedAt: fields[1] as DateTime?,
      user: fields[2] as User?,
      refreshToken: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppState obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.tokenCreatedAt)
      ..writeByte(2)
      ..write(obj.user)
      ..writeByte(3)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppState _$AppStateFromJson(Map<String, dynamic> json) => _AppState(
  accessToken: json['accessToken'] as String?,
  tokenCreatedAt: dateFromJson(json['tokenCreatedAt'] as String?),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  refreshToken: json['refreshToken'] as String?,
);

Map<String, dynamic> _$AppStateToJson(_AppState instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'tokenCreatedAt': dateToJson(instance.tokenCreatedAt),
  'user': instance.user,
  'refreshToken': instance.refreshToken,
};
