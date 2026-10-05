// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math' as math;
import 'package:hive_ce_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:project_tmp/export.dart';
part 'bootstrap.g.dart';

Future<void> _openHiveBoxSync() async {
  for (final boxName in StorageBox.values) {
    final name = boxName.toString();

    try {
      await Hive.openBox(name);
    } catch (e, s) {
      if (await Hive.boxExists(name)) {
        await Hive.deleteBoxFromDisk(name);
        await Hive.openBox(name);
      } else {
        // TODO: capture error
        // ErrorCaptureService.putError(e, stack: s);
        print('Still error opening $boxName: $e');
      }
    }
  }
}

void _registerHiveAdapters() {
  _registerHiveModelAdapters();
}


Future<void> _setUpHive() async {
  print("Check hive box");
  final directory = await getApplicationSupportDirectory();

  await Hive.initFlutter(directory.path);

  _registerHiveAdapters();

  await _openHiveBoxSync();
}

Future bootstrap() async {
  // Override HTTPS certificate warning
  HttpOverrides.global = MyHttpOverrides();

  // if (Platform.isIOS) {
  _scaleScreenDimension();
  // }

  WidgetsFlutterBinding.ensureInitialized();

  // await RiveFile.initialize();

  await _setUpHive();

  await AppState.loadGlobalValues();

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is Trace) return stack.vmTrace;
    if (stack is Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  // cacheRiveAssets();
}

// cacheRiveAssets() async {
//   final riveAssets = [
//     ...const AppAssetKeys.errorRive().allPath(),
//   ];
//
//   for (var rive in riveAssets) {
//     try {
//       // await EaRive.loadCache(rive);
//     } catch (e, stackTrace) {
//       ErrorCaptureService.putError(e, stack: stackTrace);
//     }
//   }
// }

void _scaleScreenDimension() {
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      // screen width used in your UI design
      // const widthOfDesign = 1500; //420.0;

      final shortestSide = math.min(deviceSize.width, deviceSize.height);
      ///TODO RECHECK
      return shortestSide;
      // isSmallDevice = shortestSide < 600;
      // final widthOfDesign = isSmallDevice ? 420.0 : 1500.0;
      // return math.min(deviceSize.width / widthOfDesign, 1);
    },
  );
}
