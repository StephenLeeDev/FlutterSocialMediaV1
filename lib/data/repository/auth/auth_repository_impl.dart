import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_social_media_v1/data/model/auth/auth_request.dart';

import '../../../domain/repository/auth/auth_repository.dart';
import '../../constant/constant.dart';
import '../../model/auth/auth_response.dart';
import '../../model/auth/auth_state.dart';

class AuthRepositoryImpl extends AuthRepository {

  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<AuthState> signIn({required AuthRequest authRequest}) async {
    const api = 'auth/signIn';
    const url = '$baseUrl$api';

    debugPrint("url : $url");
    debugPrint("authRequest : ${authRequest.toString()}");

    try {
      final response = await _dio.post(
        url,
        data: authRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data);
        final AuthState authState = Success(authResponse.accessToken);

        debugPrint("authResponse : ${authResponse.toString()}");

        return authState;
      }
      return Fail();
    } catch (e) {
      debugPrint("signIn Fail : ${e.toString()}");
      return Fail();
    }
  }

}
