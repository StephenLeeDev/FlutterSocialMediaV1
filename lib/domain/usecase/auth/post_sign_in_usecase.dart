import '../../../data/model/auth/auth_request.dart';
import '../../../data/model/auth/auth_state.dart';
import '../../repository/auth/auth_repository.dart';

class PostSignInUseCase {
  final AuthRepository _authRepository;

  PostSignInUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<AuthState> execute({required AuthRequest authRequest}) async {
    return await _authRepository.signIn(authRequest: authRequest);
  }

}