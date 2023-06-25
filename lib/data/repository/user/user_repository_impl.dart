import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_social_media_v1/data/model/user/my_user_info.dart';

import '../../../domain/repository/user/user_repository.dart';
import '../../constant/constant.dart';
import '../../model/common/common_state.dart' as CommonState;
import '../../model/user/my_user_info_state.dart' as MyUserInfoState;

class UserRepositoryImpl extends UserRepository {

  final Dio _dio;

  UserRepositoryImpl(this._dio);

  @override
  Future<MyUserInfoState.MyUserInfoState> getMyUserInfo() async {
    const api = 'user';
    const url = '$baseUrl$api';
    debugPrint("url : $url");

    final Response response = await _dio.get(url);
    debugPrint("response : ${response.toString()}");

    final code = response.statusCode;

    if (code == 200) {
      final state = MyUserInfoState.Success(MyUserInfo.fromJson(response.data));

      debugPrint("state : ${state.toString()}");

      return state;
    }
    else if (code == 401) {
      return MyUserInfoState.Unauthorized();
    }
    return MyUserInfoState.Fail();
  }

  @override
  Future<CommonState.CommonState> postBookmark({required int postId}) async {
    const api = 'user/post/bookmark';
    const url = '$baseUrl$api';
    debugPrint("url : $url");
    debugPrint("postId : $postId");

    final Response response = await _dio.post(url, queryParameters: {'postId': postId});

    final code = response.statusCode;

    if (code == 201) {
      final state = CommonState.Success();

      debugPrint("state : ${state.toString()}");

      return state;
    }
    else if (code == 401) {
      return CommonState.Unauthorized();
    }
    return CommonState.Fail();
  }

}