import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

bool shouldCurrencyHaveDecimal({String? currencyKey}) {
  if (['KHR', '៛'].contains(currencyKey)) {
    return false;
  }
  return true;
}

String? dateToJson(DateTime? date) {
  return date?.toUtc().toIso8601String();
}

DateTime? dateFromJson(String? date) {
  if (date == null) {
    return null;
  } else {
    return DateTime.parse(date).toLocal();
  }
}

Future<String> initAbsolutePath() async {
  return (await getApplicationSupportDirectory()).path;
}

Future<String> initAbsoluteTmpPath() async {
  return (await getTemporaryDirectory()).path;
}


Future<int?> getServerSpeedMs(String url, {int timeout = 10}) async {
  final uri = Uri.parse(url);

  Duration? speed;
  var stopWatch = Stopwatch()..start();
  try {
    Object? error;
    final completer = Completer();
    final socket1 = Socket.connect(uri.host, 80).timeout(
      Duration(seconds: timeout),
    );
    final socket2 = Socket.connect(uri.host, 443).timeout(
      Duration(seconds: timeout),
    );
    socket1.then((socket) {
      if (!completer.isCompleted) {
        completer.complete();
      }
      socket.close();
    }).catchError((e) {
      if (error != null) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
      error = e;
    });
    socket2.then((socket) {
      if (!completer.isCompleted) {
        completer.complete();
      }
      socket.close();
    }).catchError((e) {
      if (error != null) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
      error = e;
    });
    await completer.future;
    stopWatch.stop();
    speed = stopWatch.elapsed;
  } catch (e, s) {
    /// TODO fix log letter
    // s.log("Look up host: $s");
    stopWatch.stop();
    print('Failed to connect: $e');
    return speed?.inMilliseconds;
  }
  return speed.inMilliseconds;
}



Future callApi(
    FutureOr Function() request, {
      bool loading = true,
      bool showToast = true,
      int durationSeconds = 3,
      Function(Object error)? onError,
      VoidCallback? onComplete,
      String? loadingFullScreenTitle,
      bool isLoadingFullScreen = false,
    }) async {
  try {
    if (loading) {
      /// TODO Implement loading style next
      // showLoading(
      //   isFullScreen: isLoadingFullScreen,
      //   text: loadingFullScreenTitle,
      // );
    }
    await request();
    // hideInterruptLoading();
  } catch (e, s) {
    /// TODO Implement capture error and log next
    ///
    // ErrorCaptureService.putError(e, stack: s);
    // s.log("Call api");
    onError?.call(e);
    if (showToast) {
      /// TODO show toast error
      // toast(e, seconds: durationSeconds);
    }
  } finally {
    if (loading){}
    //   hideLoading();
    print("COMPLETE");
    onComplete?.call();
  }
}