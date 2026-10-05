import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_tmp/utils/services/navigation.dart';
import 'package:project_tmp/utils/services/slow_network.dart';

class CapturedAPIRequest extends ChangeNotifier {
  final int index;
  String? url;
  String? method;
  Object? requestBody;
  Object? responseData;
  Map<String, dynamic>? requestHeader;
  Map<String, dynamic>? responseHeader;
  DateTime? requestedAt;
  DateTime? respondedAt;
  int? statusCode;
  Object? error;
  DioExceptionType? dioErrorType;
  StackTrace? stackTrace;
  String? pageName;
  Duration? markSlowDuration;

  bool get isError => error != null;

  CapturedAPIRequest({
    required this.index,
    this.url,
    this.method,
    this.requestBody,
    this.responseData,
    this.requestHeader,
    this.responseHeader,
    this.requestedAt,
    this.respondedAt,
    this.pageName,
    this.markSlowDuration,
  });

  void markError(Object error) {
    this.error = error;
    if (error is DioException) {
      dioErrorType = error.type;
    }
    respondedAt = DateTime.now();
  }

  void updateResponse(Object data) {
    responseData = data;
    notify();
  }

  notify() {
    notifyListeners();
  }
}

const _maxCapture = 100;

class ApiRequestCaptureService extends Interceptor {
  static int _counter = 0;
  static final ValueNotifier<List<CapturedAPIRequest>> logs = ValueNotifier([]);
  final CapturedAPIRequest logger;

  ApiRequestCaptureService(this.logger);

  static add(CapturedAPIRequest data) {
    if (logs.value.length >= _maxCapture) {
      logs.value = [data, ...logs.value.sublist(0, _maxCapture - 1)];
    } else {
      logs.value = [data, ...logs.value];
    }
  }

  static CapturedAPIRequest create(
    Object? requestBody, {
    Duration? markShowDuration,
  }) {
    final logger = CapturedAPIRequest(
      index: _counter++,
      requestBody: requestBody,
      pageName: NavigationService.lastRouteArgument?.pageWidget.runtimeType
          .toString(),
      markSlowDuration: markShowDuration,
    );
    add(logger);
    SlowNetworkService.startTrack(
      logger,
    );
    return logger;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // print("Intercept with effect: ${options.uri}");
    logger.url = options.uri.toString();
    logger.method = options.method;
    logger.requestedAt = DateTime.now();
    logger.requestHeader = options.headers;
    logger.notify();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print("I received response");
    logger.statusCode = response.statusCode;
    logger.responseHeader = response.headers.map;
    logger.respondedAt = DateTime.now();
    logger.updateResponse(response.data);
    logger.notify();
    SlowNetworkService.stopTrack(logger);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode != null) {
      logger.statusCode = err.response?.statusCode;
    }
    if (err.response?.headers.map != null) {
      logger.responseHeader = err.response?.headers.map;
    }
    logger.respondedAt = DateTime.now();
    logger.dioErrorType = err.type;
    logger.error = err.error;
    logger.stackTrace = err.stackTrace;
    logger.notify();
    SlowNetworkService.stopTrack(logger);
    super.onError(err, handler);
  }
}
