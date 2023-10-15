import 'package:dio/dio.dart';

import '../../../domain/usecase/auth/get_access_token_usecase.dart';
import '../../../domain/usecase/auth/set_access_token_usecase.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final GetAccessTokenUseCase _getAccessTokenUseCase;
  final SetAccessTokenUseCase _setAccessTokenUseCase;

  TokenInterceptor({
    required GetAccessTokenUseCase getAccessTokenUseCase,
    required SetAccessTokenUseCase setAccessTokenUseCase,
  }) : _getAccessTokenUseCase = getAccessTokenUseCase,
        _setAccessTokenUseCase = setAccessTokenUseCase;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _getAccessTokenUseCase.execute();
    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO : Implement refreshToken feature later when the server is ready
    if (err.response?.statusCode == 401) {
      _setAccessTokenUseCase.execute(accessToken: "");
    }

    // if (err.response?.statusCode == 401) {
    //   final refreshToken = await refreshTokenUseCase.execute();
    //   if (refreshToken != null) {
    //     final newAccessToken = await getJwtUseCase.execute();
    //     err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
    //     return handler.next(err.requestOptions);
    //   }
    // }

    return super.onError(err, handler);
  }
}