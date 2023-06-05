import '../../repository/auth/auth_repository.dart';

class SetAccessTokenUseCase {
  final AuthRepository _authRepository;

  SetAccessTokenUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> execute({required String accessToken}) async {
    await _authRepository.setAccessTokenFromSecureStorage(accessToken: accessToken);
  }

}