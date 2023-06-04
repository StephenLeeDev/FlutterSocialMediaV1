import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_social_media_v1/data/model/auth/auth_request.dart';

import '../../../domain/repository/auth/auth_repository.dart';
import '../../constant/constant.dart';
import '../../model/auth/auth_response.dart';
import '../../model/auth/auth_state.dart';

class AuthRepositoryImpl extends AuthRepository {

  final dio = Dio();
  final storage = const FlutterSecureStorage();

  @override
  Future<String> getAccessTokenFromSecureStorage() async {
    String accessToken = await storage.read(key: 'accessToken') ?? "";
    return accessToken;
  }

  @override
  Future<void> setAccessTokenFromSecureStorage({required String accessToken}) async {
    await storage.write(key: 'accessToken', value: accessToken);
  }

  @override
  Future<AuthState> signIn({required AuthRequest authRequest}) async {
    const api = 'auth/signIn';
    const url = '$baseUrl$api';

    debugPrint("url : $url");
    debugPrint("authRequest : ${authRequest.toString()}");

    final response = await dio.post(
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
  }

}
