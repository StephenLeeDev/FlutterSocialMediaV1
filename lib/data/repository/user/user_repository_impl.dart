import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_social_media_v1/data/model/user/my_user_info.dart';

import '../../../domain/repository/user/user_repository.dart';
import '../../constant/constant.dart';
import '../../model/user/my_user_info_state.dart';

class UserRepositoryImpl extends UserRepository {

  final Dio _dio;

  UserRepositoryImpl(this._dio);

  @override
  Future<MyUserInfoState> getMyUserInfo() async {

    const api = 'user';
    const url = '$baseUrl$api';

    debugPrint("url : $url");

    final Response response = await _dio.get(url);
    debugPrint("response : ${response.toString()}");

    final code = response.statusCode;

    if (code == 200) {
      final MyUserInfoState myUserInfoState = Success(MyUserInfo.fromJson(response.data));

      debugPrint("myUserInfoState : ${myUserInfoState.toString()}");

      return myUserInfoState;
    }
    else if (code == 401) {
      return Unauthorized();
    }
    return Fail();
  }

}