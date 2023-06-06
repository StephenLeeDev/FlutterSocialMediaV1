abstract class SecureStorageRepository {
  Future<String> getAccessTokenFromSecureStorage();
  Future<void> setAccessTokenFromSecureStorage({required String accessToken});
}