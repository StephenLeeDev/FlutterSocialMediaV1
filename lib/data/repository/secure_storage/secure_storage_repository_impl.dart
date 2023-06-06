import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../domain/repository/secure_storage/secure_storage_repository.dart';

class SecureStorageRepositoryImpl extends SecureStorageRepository {

  final _storage = const FlutterSecureStorage();

  @override
  Future<String> getAccessTokenFromSecureStorage() async {
    String accessToken = await _storage.read(key: 'accessToken') ?? "";
    return accessToken;
  }

  @override
  Future<void> setAccessTokenFromSecureStorage({required String accessToken}) async {
    await _storage.write(key: 'accessToken', value: accessToken);
  }
}