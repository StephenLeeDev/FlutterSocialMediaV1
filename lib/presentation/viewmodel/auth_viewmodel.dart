import 'package:flutter/foundation.dart';
import 'package:flutter_social_media_v1/data/model/auth/auth_request.dart';
import 'package:flutter_social_media_v1/data/model/auth/auth_state.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/post_sign_in_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final PostSignInUseCase _postSignInUseCase;

  AuthViewModel({
    required PostSignInUseCase postSignInUseCase,
  }) : _postSignInUseCase = postSignInUseCase;

  AuthState authState = Loading();

  Future<void> signIn({required AuthRequest authRequest}) async {
    authState = await _postSignInUseCase.execute(authRequest: authRequest);
  }

}