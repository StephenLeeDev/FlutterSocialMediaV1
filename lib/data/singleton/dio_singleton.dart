import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioSingleton {
  static Dio? _instance;

  static Dio getInstance({String accessToken = ""}) {
    if (_instance == null) {
      _instance = Dio();
      _instance?.options.headers['Authorization'] = 'Bearer $accessToken';

      _instance?.interceptors.add(
        InterceptorsWrapper(
          onError: (DioError error, handler) {
            debugPrint('Dio Error: ${error.toString()}');
          },
        ),
      );
    }
    return _instance!;
  }

  static setAuthorization({required String accessToken}) {
    _instance?.options.headers['Authorization'] = 'Bearer $accessToken';
  }
}
