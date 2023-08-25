import 'package:flutter/foundation.dart';

import '../../../data/model/auth/auth_request.dart';
import '../../../data/model/auth/auth_state.dart';
import '../../../domain/usecase/auth/post_sign_in_usecase.dart';
import '../../../domain/usecase/auth/set_access_token_usecase.dart';

// TODO : Replace with ValueNotifier later
class AuthViewModel extends ChangeNotifier {
  final PostSignInUseCase _postSignInUseCase;
  final SetAccessTokenUseCase _setAccessTokenUseCase;

  AuthViewModel({
    required PostSignInUseCase postSignInUseCase,
    required SetAccessTokenUseCase setAccessTokenUseCase,
  }) : _postSignInUseCase = postSignInUseCase,
        _setAccessTokenUseCase = setAccessTokenUseCase;

  AuthState _authState = Loading();
  AuthState get authState => _authState;

  setAuthState({required AuthState authState}) {
    _authState = authState;
  }

  Future<void> signIn({required AuthRequest authRequest}) async {
    final state = await _postSignInUseCase.execute(authRequest: authRequest);
    if (state is Success) {
      _setAccessTokenUseCase.execute(accessToken: state.getAccessToken);
    }
    setAuthState(authState: state);
  }

}