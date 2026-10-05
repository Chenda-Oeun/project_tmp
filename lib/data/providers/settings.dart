//
//
// import 'package:flutter/material.dart';
//
// class SettingProvider extends ChangeNotifier {
//   late Setting inner;
//
//   SettingProvider.init() {
//     inner = Setting.fromStorage();
//   }
//
//   notifyProvider() {
//     notifyListeners();
//   }
//
//   invalidate() {
//     // inner = Setting();
//   }
// }
//
// final settingProvider = ChangeNotifierProvider(
//       (ref) => SettingProvider.init(),
// );
