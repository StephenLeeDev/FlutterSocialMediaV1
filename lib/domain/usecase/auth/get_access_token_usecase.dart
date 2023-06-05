import '../../repository/auth/auth_repository.dart';

class GetAccessTokenUseCase {
  final AuthRepository _authRepository;

  GetAccessTokenUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<String> execute() async {
    return await _authRepository.getAccessTokenFromSecureStorage();
  }

}