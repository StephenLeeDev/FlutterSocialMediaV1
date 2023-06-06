import '../../repository/secure_storage/secure_storage_repository.dart';

class GetAccessTokenUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetAccessTokenUseCase({required SecureStorageRepository secureStorageRepository})
      : _secureStorageRepository = secureStorageRepository;

  Future<String> execute() async {
    return await _secureStorageRepository.getAccessTokenFromSecureStorage();
  }

}