import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/get_access_token_usecase.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final GetAccessTokenUseCase getAccessTokenUseCase;

  TokenInterceptor({required this.getAccessTokenUseCase});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getAccessTokenUseCase.execute();
    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }
}