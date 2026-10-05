part of 'bootstrap.dart';

void _registerHiveModelAdapters() {
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AppStateAdapter());
  Hive.registerAdapter(SettingAdapter());
}
