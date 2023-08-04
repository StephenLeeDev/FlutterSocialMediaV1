import 'package:dio/dio.dart';

class DioSingleton {
  static Dio? _instance;

  static Dio getInstance() {
    _instance ??= Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
    return _instance!;
  }
}
