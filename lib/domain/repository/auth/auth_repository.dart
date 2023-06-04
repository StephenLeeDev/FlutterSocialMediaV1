import 'package:flutter_social_media_v1/data/model/auth/auth_request.dart';

import '../../../data/model/auth/auth_state.dart';

abstract class AuthRepository {
  Future<String> getAccessTokenFromSecureStorage();
  Future<void> setAccessTokenFromSecureStorage({required String accessToken});
  Future<AuthState> signIn({required AuthRequest authRequest});
}
