import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../domain/repository/secure_storage/secure_storage_repository.dart';

class SecureStorageRepositoryImpl extends SecureStorageRepository {

  final _storage = const FlutterSecureStorage();

  @override
  Future<String> getAccessTokenFromSecureStorage() async {
    /// It's rarely occurs PlatformException issue below (Only on Android)
    /// I don't know the clear reason yet
    /// I added try/catch as a guard code
    ///
    /// [Error] PlatformException(Exception encountered, read, javax.crypto.BadPaddingException
    try {
      String accessToken = await _storage.read(key: 'accessToken') ?? "";
      return accessToken;
    } catch (e) {
      debugPrint("getAccessTokenFromSecureStorage : ${e.toString()}");
      return "";
    }
  }

  @override
  Future<void> setAccessTokenFromSecureStorage({required String accessToken}) async {
    await _storage.write(key: 'accessToken', value: accessToken);
  }
}