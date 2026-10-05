// ignore_for_file: invalid_annotation_target

import 'package:hive_ce/hive_ce.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_tmp/utils/helpers/accessors.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
@unfreezedNoCopy
abstract class User with  _$User {
  User._();

  factory User(
      {@HiveField(0) @JsonKey(name: '_id') required String id,
      @HiveField(1) required String name,
      @HiveField(2) String? phoneNumber,
      @HiveField(3) String? avatar,
      }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  @override
  bool operator ==(Object other) {
    if (other is User) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;
}
