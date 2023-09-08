import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/auth/auth_repository.dart';
import '../../constant/constant.dart';
import '../../model/auth/auth_request.dart';
import '../../model/auth/auth_response.dart';
import '../../model/auth/auth_state.dart';

class AuthRepositoryImpl extends AuthRepository {

  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<AuthState> signIn({required AuthRequest authRequest}) async {
    const api = 'auth/signIn';
    const url = '$baseUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: authRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data);
        final AuthState state = Success(authResponse.accessToken);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return Fail();
    } catch (e) {
      return Fail();
    }
  }

}
