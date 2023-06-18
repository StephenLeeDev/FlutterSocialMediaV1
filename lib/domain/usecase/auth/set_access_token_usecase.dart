import '../../../data/singleton/dio_singleton.dart';
import '../../repository/secure_storage/secure_storage_repository.dart';

class SetAccessTokenUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetAccessTokenUseCase({required SecureStorageRepository secureStorageRepository})
      : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required String accessToken}) async {
    DioSingleton.setAuthorization(accessToken: accessToken);
    await _secureStorageRepository.setAccessTokenFromSecureStorage(accessToken: accessToken);
  }

}