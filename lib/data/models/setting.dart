import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:project_tmp/utils/helper/accessors.dart';

part 'setting.freezed.dart';
part 'setting.g.dart';


@HiveType(typeId: 1)
@unfreezedNoCopy
abstract class Setting with _$Setting {
  static const key = "000";

  // 1. Private constructor required for custom methods (save, toggleDarkMode)
  const Setting._();

  // 2. Factory constructor with @HiveField annotations
  factory Setting({
    @HiveField(0) bool? darkMode,
  }) = _Setting;

  factory Setting.fromJson(Map<String, Object?> json) =>
      _$SettingFromJson(json);

  // Custom methods inside the class
  Future<void> save({bool silent = false}) async {
    if (!silent) notify();
  }

  factory Setting.fromStorage() => Setting();

  void toggleDarkMode() => save();

  void notify() {
  }
}