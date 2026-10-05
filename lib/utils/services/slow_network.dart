import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:project_tmp/data/providers/slow_network.dart';
import 'package:project_tmp/utils/helper/accessors.dart';
import 'package:project_tmp/utils/helper/general.dart';
import 'package:project_tmp/utils/services/request_capture.dart' show CapturedAPIRequest;


const slowNetworkDuration = Duration(seconds: 5);
const logExpirationDuration = Duration(seconds: 30);
Timer? _internetFastAgainDebounce;

class SlowNetworkService {
  static bool _shouldTrack(CapturedAPIRequest logger) {
    return logger.requestBody is! FormData;
  }

  static bool _isLoggerSlow(CapturedAPIRequest logger) {
    return logger.error is TimeoutException ||
        logger.error is SocketException ||
        logger.dioErrorType == DioExceptionType.connectionTimeout ||
        logger.dioErrorType == DioExceptionType.sendTimeout ||
        logger.dioErrorType == DioExceptionType.receiveTimeout;
  }

  static final Map<CapturedAPIRequest, Timer> _timers = {};

  static bool get hasSlowRequest =>
      _timers.values.any((timer) => !timer.isActive);

  static final List<String> testableServers = [
    'google.com',
    'baidu.com',
    'yandex.ru',
  ];

  static Future<Duration?> getInternetSpeed() async {
    final completer = Completer<Duration?>();
    var count = testableServers.length;

    final timer = Timer(slowNetworkDuration + const Duration(seconds: 1), () {
      if (!completer.isCompleted) {
        completer.complete(slowNetworkDuration + const Duration(seconds: 1));
      }
    });

    for (var server in testableServers) {
      getServerSpeedMs('https://$server').then((speed) {
        count--;
        if (!completer.isCompleted) {
          if (speed != null) {
            completer.complete(Duration(milliseconds: speed));
            timer.cancel();
            return;
          }
          if (count == 0) {
            completer.complete(null);
            timer.cancel();
          }
        }
      });
    }
    return await completer.future;
  }

  static updateInternetSpeed() async {
    final speed = await getInternetSpeed();
    print("Internet speed is : $speed ms");
    if (speed != null && speed < slowNetworkDuration) {
      if (appRef.read(realSlowNetworkProvider)) {
        clearSlowLogs();
        setSlowNetworkProvider(hasSlowRequest);
      }
    } else {
      // If internet still slow, check next 3 seconds
      _internetFastAgainDebounce?.cancel();
      _internetFastAgainDebounce = Timer(
        const Duration(seconds: 3),
        () {
          updateInternetSpeed();
        },
      );
    }
  }

  static startTrack(CapturedAPIRequest logger) {
    print("Start to track : -----");
    if (!_shouldTrack(logger)) {
      return;
    }
    final timer = Timer(
      logger.markSlowDuration ?? slowNetworkDuration,
      () {
        setSlowNetworkProvider(hasSlowRequest);
      },
    );
    _timers[logger] = timer;
    Timer(logExpirationDuration, () {
      stopTrack(logger);
    });
  }

  static stopTrack(CapturedAPIRequest logger) {
    if (!_shouldTrack(logger)) {
      return;
    }

    if (_timers.containsKey(logger)) {
      if (_timers[logger]!.isActive) {
        _timers[logger]!.cancel();
      }
    } else {
      return;
    }

    if (!_isLoggerSlow(logger)) {
      _timers.remove(logger);
      clearSlowLogs();
    }

    if (hasSlowRequest) {
      setSlowNetworkProvider(true);
      // If internet slow, check next 3 seconds
      _internetFastAgainDebounce?.cancel();
      _internetFastAgainDebounce = Timer(
        const Duration(seconds: 3),
        () {
          updateInternetSpeed();
        },
      );
    } else {
      setSlowNetworkProvider(false);
    }
  }

  static void clearSlowLogs() {
    var keysForRemove = [];
    for (var l in _timers.keys) {
      if (_timers.containsKey(l) && !_timers[l]!.isActive) {
        if (_isLoggerSlow(l)) {
          keysForRemove.add(l);
        }
      }
    }
    for (var key in keysForRemove) {
      _timers.remove(key);
    }
  }
}
