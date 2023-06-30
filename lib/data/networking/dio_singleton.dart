import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioSingleton {
  static Dio? _instance;

  static Dio getInstance() {
    if (_instance == null) {
      _instance = Dio();

      _instance?.interceptors.add(
        InterceptorsWrapper(
          onError: (DioException exception, handler) {
            debugPrint('DioException: ${exception.toString()}');
          },
        ),
      );
    }
    return _instance!;
  }
}
