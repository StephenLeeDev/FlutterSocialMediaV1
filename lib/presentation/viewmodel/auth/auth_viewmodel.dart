import 'package:flutter/foundation.dart';

import '../../../data/model/auth/auth_request.dart';
import '../../../data/model/auth/auth_state.dart';
import '../../../domain/usecase/auth/post_sign_in_usecase.dart';
import '../../../domain/usecase/auth/set_access_token_usecase.dart';

// TODO : Replace with ValueNotifier later
class AuthViewModel {
  final PostSignInUseCase _postSignInUseCase;
  final SetAccessTokenUseCase _setAccessTokenUseCase;

  AuthViewModel({
    required PostSignInUseCase postSignInUseCase,
    required SetAccessTokenUseCase setAccessTokenUseCase,
  }) : _postSignInUseCase = postSignInUseCase,
        _setAccessTokenUseCase = setAccessTokenUseCase;

  /// It represents UI state
  final ValueNotifier<AuthState> _authState = ValueNotifier<AuthState>(Ready());
  ValueNotifier<AuthState> get authStateNotifier => _authState;
  AuthState get authState => _authState.value;

  setAuthState({required AuthState state}) {
    _authState.value = state;
  }

  Future<void> signIn({required AuthRequest authRequest}) async {
    /// Avoiding multiple calling
    if (authState is Loading) return;
    setAuthState(state: Loading());

    final state = await _postSignInUseCase.execute(authRequest: authRequest);
    if (state is Success) {
      await _setAccessTokenUseCase.execute(accessToken: state.getAccessToken);
    }
    setAuthState(state: state);
  }

}