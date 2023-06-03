import 'package:flutter_social_media_v1/data/model/auth/auth_request.dart';
import 'package:flutter_social_media_v1/domain/repository/auth/auth_repository.dart';

import '../../../data/model/auth/auth_state.dart';

class PostSignInUseCase {
  final AuthRepository _authRepository;

  PostSignInUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<AuthState> execute({required AuthRequest authRequest}) async {
    return await _authRepository.signIn(authRequest: authRequest);
  }

}