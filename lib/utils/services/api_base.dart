
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project_tmp/utils/exceptions/error_from_server_exception.dart';
import 'package:project_tmp/utils/helper/accessors.dart';
import 'package:project_tmp/utils/services/request_capture.dart';

class Api {
  static Dio getDio() {
    // var platform = "";
    //
    // switch (defaultTargetPlatform) {
    //   case TargetPlatform.windows:
    //     platform = 'windows';
    //     break;
    //   case TargetPlatform.android:
    //     platform = 'android';
    //     break;
    //   case TargetPlatform.iOS:
    //     platform = 'ios';
    //     break;
    //   default:
    // }

    return Dio(
      BaseOptions(
        baseUrl: "baseUrl here",
      ),
    )
      ..options.headers = {
        'Authorization': 'Bearer accessToken',
        'x-device-id': "deviceId",
        'app-version': "actualVersion",
        // 'platform': platform,
      }
      ..interceptors.addAll(
        [
          LogInterceptor(
            requestBody: true,
            responseBody: true,
          ),
        ],
      );
  }

  static Future<Map<String, dynamic>?> post({
    required String path,
    Map<String, dynamic>? data,
    bool refreshTokenAttempted = false,
    Map<String, File>? files,
    CancelToken? cancelToken,
    Function(int updated, int total)? onSendProgress,
    Function(int updated, int total)? onReceiveProgress,
  }) async {
    return await _request(
      method: 'POST',
      path: path,
      data: data,
      files: files,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      refreshTokenAttempted: refreshTokenAttempted,
    );
  }

  static Future<Map<String, dynamic>?> put({
    required String path,
    Map<String, dynamic>? data,
    bool refreshTokenAttempted = false,
    CancelToken? cancelToken,
    Function(int updated, int total)? onSendProgress,
    Function(int updated, int total)? onReceiveProgress,
  }) async {
    return await _request(
      method: 'PUT',
      path: path,
      data: data,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      refreshTokenAttempted: refreshTokenAttempted,
    );
  }

  static Future<Map<String, dynamic>?> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    bool refreshTokenAttempted = false,
    CancelToken? cancelToken,
    Function(int updated, int total)? onSendProgress,
    Function(int updated, int total)? onReceiveProgress,
  }) async {

    return await _request(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      refreshTokenAttempted: refreshTokenAttempted,
    );
  }

  static Future<Map<String, dynamic>?> delete({
    required String path,
    Map<String, dynamic>? data,
    bool refreshTokenAttempted = false,
    CancelToken? cancelToken,
  }) async {
    return await _request(
      method: 'DELETE',
      path: path,
      data: data,
      cancelToken: cancelToken,
      refreshTokenAttempted: refreshTokenAttempted,
    );
  }

  static Future<Map<String, dynamic>?> _request({
    required String method,
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool refreshTokenAttempted = false,
    Map<String, File>? files,
    CancelToken? cancelToken,
    Function(int updated, int total)? onSendProgress,
    Function(int updated, int total)? onReceiveProgress,
    Duration? markShowDuration,
  }) async {
    try {
      final _dio = getDio();

      final apiLogger = ApiRequestCaptureService.create(
        data,
        markShowDuration: markShowDuration,
      );

      _dio.interceptors.add(
        ApiRequestCaptureService(apiLogger),
      );

      final response = await () async {
        switch (method.toUpperCase()) {
          case 'GET':
            return _dio.get(
              path,
              queryParameters: queryParameters,
              onReceiveProgress: onReceiveProgress,
            );
          case 'POST':
            if (files != null && files.isNotEmpty) {
              _dio.options.headers.addAll({
                Headers.contentTypeHeader: Headers.multipartFormDataContentType,
                Headers.acceptHeader: Headers.jsonContentType,
                'app-version': appState.actualVersion,
              });

              Map<String, dynamic> formDataMap = {
                if (data != null) ...data,
              };

              for (final entry in files.entries) {
                final file = entry.value;

                final totalBytes = await file.length();
                final stream = file.openRead(0, totalBytes);
                final multipartFile = MultipartFile.fromStream(
                      () => stream,
                  totalBytes,
                  filename: "file.filename",//TODO
                  // '${DateTime.now().millisecondsSinceEpoch}_${file.filename}'
                );

                formDataMap[entry.key] = multipartFile;
              }

              final formData = FormData.fromMap(formDataMap);

              apiLogger.requestBody = formData;

              return _dio.post(
                path,
                data: formData,
                queryParameters: queryParameters,
                onSendProgress: onSendProgress,
                onReceiveProgress: onReceiveProgress,
              );
            } else {
              return _dio.post(
                path,
                data: data,
                onSendProgress: onSendProgress,
                onReceiveProgress: onReceiveProgress,
              );
            }
          case 'PUT':
            return _dio.put(
              path,
              data: data,
              queryParameters: queryParameters,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            );
          case 'DELETE':
            return _dio.delete(
              path,
              data: data,
              queryParameters: queryParameters,
            );
          default:
            throw Exception('Invalid method: $method');
        }
      }();
      print("Response from [$method]:$path");
      /// TODO
      // if (kDebugMode) {
      //   /// Sorry, there are many api log responses i ignored some api logs😅
      //   final _shouldIgnoreDebug = _shouldIgnoreDebugUrl(path);
      //   if (!_shouldIgnoreDebug) {
      //     debugPrint(prettifyJsonEncode(response.data).fixCrash());
      //   }
      // }

      if (response.data == null) {
        return null;
      }
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      final shouldRefreshToken = e.response?.statusCode == 401 &&
          appState.isLoggedIn &&
          refreshTokenAttempted == false;
      print("shouldRefreshToken : ${appState.isLoggedIn}");
      if (shouldRefreshToken) {
        if (appState.isLoggedIn) {
          /// TODO refresh token
          // await RefreshTokenService.refreshToken();
        }
        print('Refreshed token ::::::::');
        /// TODO print json format next
        // print("Data after refresh token : ${prettifyJsonEncode(data)}");
        return await _request(
          method: method,
          path: path,
          data: data,
          queryParameters: queryParameters,
          refreshTokenAttempted: true,
        );
      }

      throw ErrorFromServerException.fromError(e);
    } catch (e) {
      rethrow;
    }
  }
}

// bool _shouldIgnoreDebugUrl(String url) {
//   final uri = Uri.parse(url);
//
//   final path = '/${uri.pathSegments.take(2).join('/')}';
//
//   return ignoreDebugPaths.contains(path);
// }

// class RefreshTokenService {
//   static Completer? _refreshCompleter;
//
//   static refreshToken() async {
//     if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
//       return await _refreshCompleter!.future;
//     }
//
//     openSessionExpired() {
//       appState.logout(needNotifyApi: false);
//       OnScreenSessionService.closeLockScreenPage();
//       if (isSmallDevice) {
//         if (!isOnPageType<PortraitSessionExpiredPage>()) {
//           print("Logout completely!");
//           NavigationService.pushReplacementAll(
//             PortraitSessionExpiredPage(),
//             transition: PageTransitions.fade,
//           );
//         }
//       } else {
//         if (!isOnPageType<SessionExpiredPage>()) {
//           print("Logout completely!");
//           NavigationService.pushReplacementAll(
//             SessionExpiredPage(),
//             transition: PageTransitions.fade,
//           );
//         }
//       }
//     }
//
//     _refreshCompleter = Completer();
//
//     final refreshToken = appState.refreshToken;
//     if (refreshToken == null) {
//       final error = SessionExpiredException(T.sessionIsExpired.r);
//       print("Complete 1");
//       _refreshCompleter!.completeError(error);
//       openSessionExpired();
//       throw error;
//     }
//
//     try {
//       final data = await AuthRepository.refreshToken(refreshToken);
//       print("Complete 2");
//       _refreshCompleter!.complete(data);
//     } catch (e) {
//       print("Complete 3");
//       _refreshCompleter!.completeError(e);
//       openSessionExpired();
//       throw SessionExpiredException(e);
//     }
//   }
// }