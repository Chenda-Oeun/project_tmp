import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:project_tmp/data/enums/storage_box.dart';
import 'package:project_tmp/data/models/user.dart';
import 'package:project_tmp/utils/constants/storage_keys.dart';
import 'package:project_tmp/utils/helper/accessors.dart';
import 'package:project_tmp/utils/helper/general.dart';
import 'package:project_tmp/utils/services/storage.dart';


part 'app_state.freezed.dart';
part 'app_state.g.dart';


@HiveType(typeId: 0)
@unfreezedNoCopy


// class AppState extends ChangeNotifier with _$
abstract class AppState extends ChangeNotifier with _$AppState{
  static const key = StorageKeys.appState;

  static late bool _isSupportCamera;
  static late Locale _systemLanguage;
  static Size? _screenSize;
  static late EdgeInsets _safePadding;
  static late String _deviceId;
  static late String _userAgent;
  static late BaseDeviceInfo _platformInfo;
  static late String _version;
  static late String _buildNumber;
  static late String _absolutePathDirectory;
  static late String _absoluteTmpPathDirectory;
  static late double _devicePixelRatio;
  static late double _textScaleFactor;
  static late String? _timeZone;
  static bool? _isSystemDarkMode;
  static final List<String> _assets = [];

  static bool _newRegistered = false;
  static bool _justVerified = false;
  static bool _finishedTutorial = false;
  static Completer? _introCompleter;

  bool get justVerified => _justVerified;

  String get timeZone => _timeZone ?? DateTime.now().timeZoneName;

  setJustVerified(bool value) {
    _justVerified = value;
  }

  bool get isSupportCamera => _isSupportCamera;

  bool get finishedTutorial => _finishedTutorial;

  setFinishedTutorial(bool value) {
    _finishedTutorial = value;
  }

  Completer? get introCompleter => _introCompleter;

  setIntroCompleter(Completer? completer) {
    _introCompleter = completer;
  }

  bool hasIntroCompleter() => _introCompleter != null;

  bool get newRegistered => _newRegistered;

  setNewRegistered(value) {
    _newRegistered = value;
  }


  String get deviceName {
    return Platform.isIOS
        ? (_platformInfo as IosDeviceInfo).utsname.nodename
        : (_platformInfo as AndroidDeviceInfo).model;
  }

  String get deviceModel {
    return Platform.isIOS
        ? (_platformInfo as IosDeviceInfo).model
        : (_platformInfo as AndroidDeviceInfo).brand;
  }

  String get deviceProductName {
    /// TODO recheck  productName
    return Platform.isIOS
        ? (_platformInfo as IosDeviceInfo).utsname.sysname
        : '${(_platformInfo as AndroidDeviceInfo).brand} ${(_platformInfo as AndroidDeviceInfo).model}';
  }

  String get systemVersion {
    return Platform.isIOS
        ? (_platformInfo as IosDeviceInfo).systemVersion
        : (_platformInfo as AndroidDeviceInfo).version.release;
  }

  bool get isLoggedIn => accessToken != null;

  List<String> get assets => _assets;

  String get version => _version;

  String get absolutePathDirectory => _absolutePathDirectory;

  String get absoluteTmpPathDirectory => _absoluteTmpPathDirectory;

  String get buildNumber => _buildNumber;

  Locale get systemLanguage => _systemLanguage;

  bool get hasScreenSize => _screenSize != null;

  String get actualVersion => "$version+$buildNumber";

  Size get screenSize {
    if (_screenSize == null) {
      return const Size(350, 500);
    }
    return _screenSize!;
  }

  EdgeInsets get safePadding => _safePadding;

  double get bottomSpace {
    return (_safePadding.bottom + (Platform.isAndroid ? 10 : 0));
  }

  String get deviceId {
    // if (showFloatingDebugTool) {
    //   var debugDeviceId = StorageService.get(key: StorageKeys.debugDeviceId);
    //   if (debugDeviceId is String) {
    //     return debugDeviceId;
    //   }
    // }

    return _deviceId;
  }

  String get userAgent => _userAgent;

  double get devicePixelRatio => _devicePixelRatio;

  double get textScaleFactor => _textScaleFactor;

  bool? get isSystemDarkMode => _isSystemDarkMode;

  BaseDeviceInfo get platformInfo => _platformInfo;

  AppState._();

  factory AppState({
    @HiveField(0) String? accessToken,
    @HiveField(1)
    @JsonKey(fromJson: dateFromJson, toJson: dateToJson)
    DateTime? tokenCreatedAt,
    @HiveField(2) User? user,
    @HiveField(3) String? refreshToken,
  }) = _AppState;

  static Future _collectAllAssetPaths() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    _assets.clear();
    _assets.addAll(assetManifest
        .listAssets()
        .where((string) => string.startsWith("assets/"))
        .toList());
  }

  String get currency => /*user?.defaultCurrency ??*/ '\$';

  String get currencyKey => 'USD';

  static Future _fetchSystemLocale() async {
    _systemLanguage = PlatformDispatcher.instance.locale;
  }

  static _updateScreenInfo(BuildContext context) {
    _devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    _screenSize = MediaQuery.of(context).size;
    _safePadding = MediaQuery.of(context).padding;
    _textScaleFactor = MediaQuery.of(context).textScaler.scale(1);
  }

  static Future _updateDeviceId() async {
    Future<String?> getId() async {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        // const androidIdPlugin = AndroidId();
        // final String? androidId = await androidIdPlugin.getId();
        // return androidId;
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id; // unique ID on Android
      }
      return null;
    }

    _deviceId = await getId() ?? "";
  }

  static Future _updateTimeZone() async {
    /// TODO Check later
    _timeZone = (await FlutterTimezone.getLocalTimezone()) as String?;
  }

  static Future _updateUserAgent() async {
    _userAgent = 'Unknown';
    // await FkUserAgent.init();
    // _userAgent = FkUserAgent.userAgent!;
  }

  static Future _updatePlatformInfo() async {
    _platformInfo = Platform.isIOS
        ? await DeviceInfoPlugin().iosInfo
        : await DeviceInfoPlugin().androidInfo;
  }

  static Future _updateVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }


  static Future loadGlobalValues() async {
    await Future.wait([
      _collectAllAssetPaths(),
      _fetchSystemLocale(),
      _updateDeviceId(),
      _updateUserAgent(),
      _updatePlatformInfo(),
      _updateVersionInfo(),
      _updateTimeZone(),
      _updateAbsolutePathDirectory(),
      _updateSystemDarkMode(),
    ]);
  }

  // static Future _updatePatchNumber() async {
  //   try {
  //     _patchNumber = await ShorebirdService.currentPatchVersion();
  //   } catch (_) {
  //     _patchNumber = null;
  //   }
  // }

  static Future _updateAbsolutePathDirectory() async {
    _absolutePathDirectory = await initAbsolutePath();
    _absoluteTmpPathDirectory = await initAbsoluteTmpPath();
  }

  static Future _updateSystemDarkMode() async {
    _isSystemDarkMode =
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
  }

  static loadContextBasedValues(BuildContext context) {
    _updateScreenInfo(context);
  }

  notify() {
    notifyListeners();
  }

  Future save() async {
    if (kDebugMode) {}
    await StorageService.put(
      key: key,
      data: this,
      boxName: StorageBox.settingBox,
    );
    notifyListeners();
  }

////
  Future resetAuth() async {
    accessToken = null;
    refreshToken = null;
    appState.setNewRegistered(false);
    _finishedTutorial = false;
    _justVerified = false;
    user = null;
    save();
  } ///////

  Future resetAll() async {
    accessToken = null;
    await save();
  }

  factory AppState.fromStorage() {
    final result = StorageService.get(
      key: key,
      boxName: StorageBox.settingBox,
      defaultValue: AppState(),
    );
    return result;
  }

  factory AppState.fromJson(Map<String, Object?> json) =>
      _$AppStateFromJson(json);

  Future logout({bool needNotifyApi = true}) async {
    callApi(
      () async {
        /// This code not work
        // final mainContext = appRef.read(mainContextProvider).inner;
        // final order = mainContext.currentOrder;
        //
        // if (order?.isPosPaid ?? false) {
        //   mainContext.switchViewOrderDineIn(order!);
        // } else {
        //   order?.status = OrderStatus.pending;
        // }
        // appRef.read(viewingCartProvider.notifier).state = true;
        // appRef.read(mainContextProvider).inner.notify();
        //
        // Future.delayed(Duration(seconds: 2));

        if (needNotifyApi) {
          /// TODO call api logout before logout
          // await AuthRepository.logout();
        }
        /// TODO Check before logout
        // await onBeforeLogout();
        appState.resetAuth();
      },
    );
  }

  String? getAccessToken() {
    return accessToken;
  }

  Future setToken(String token, String userId) async {
    appState.accessToken = token;
    appState.tokenCreatedAt = DateTime.now();
    await appState.save();
    print("Just set token");
  }

  Future setRefreshToken(String token, String userId) async {
    appState.refreshToken = token;
    await appState.save();
  }

  whenCompleteIntro() async {
    if (_introCompleter != null) {
      await _introCompleter!.future;
    }
  }

  Map<String, dynamic> collectInfo() {
    return {
      'timeZone': timeZone,
      'isSupportCamera': isSupportCamera,
      'finishedTutorial': finishedTutorial,
      'deviceName': deviceName,
      'deviceModel': deviceModel,
      'deviceProductName': deviceProductName,
      'systemVersion': systemVersion,
      'isLoggedIn': isLoggedIn,
      'version': version,
      'absolutePathDirectory': absolutePathDirectory,
      'absoluteTmpPathDirectory': absoluteTmpPathDirectory,
      'buildNumber': buildNumber,
      'systemLanguage': systemLanguage.toString(),
      'deviceId': deviceId,
      'userAgent': userAgent,
      'devicePixelRatio': devicePixelRatio,
      'textScaleFactor': textScaleFactor,
      'isSystemDarkMode': isSystemDarkMode,
      'platformInfo': platformInfo.data,
    };
  }
}
