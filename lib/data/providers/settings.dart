
import 'package:flutter_riverpod/legacy.dart';
import 'package:project_tmp/export.dart';

class SettingProvider extends ChangeNotifier {
  late Setting settings;


  SettingProvider.init() {
    settings = Setting.fromStorage();
  }

  void notifyProvider() {
    notifyListeners();
  }

  void invalidate() {
    settings = Setting();
  }
}

final settingProvider = ChangeNotifierProvider(
      (ref) => SettingProvider.init(),
);



final counterProvider = StateProvider<int>((ref) {
  return 0;
});