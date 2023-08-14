import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/user/user_repository.dart';
import '../../constant/constant.dart';
import '../../model/common/common_state.dart' as CommonState;
import '../../model/common/single_string_state.dart' as SingleStringState;
import '../../model/user/my_user_info.dart';
import '../../model/user/my_user_info_state.dart' as MyUserInfoState;

class UserRepositoryImpl extends UserRepository {

  final Dio _dio;

  UserRepositoryImpl(this._dio);

  @override
  Future<MyUserInfoState.MyUserInfoState> getMyUserInfo() async {
    const api = 'user';
    const url = '$baseUrl$api';

    try {
      final Response response = await _dio.get(url);

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
    } catch (e) {
      return MyUserInfoState.Fail();
    }
  }

  @override
  Future<CommonState.CommonState> postBookmark({required int postId}) async {
    const api = 'user/post/bookmark';
    const url = '$baseUrl$api';

    final Response response = await _dio.post(url, queryParameters: {'postId': postId});

    try {
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
    } catch (e) {
      return CommonState.Fail();
    }
  }

  @override
  Future<SingleStringState.SingleStringState> updateUserThumbnail({required MultipartFile newThumbnail}) async {
    const api = 'user/thumbnail';
    const url = '$baseUrl$api';

    _dio.options.contentType = 'multipart/form-data';

    final formData = FormData.fromMap({
      'file': newThumbnail
    });

    try {
      final response = await _dio.patch(url, data: formData);

      if (response.statusCode == 200) {
        final state = SingleStringState.Success(response.data['updatedThumbnail']);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return SingleStringState.Fail();
    } catch (e) {
      return SingleStringState.Fail();
    } finally {
      /// Initialize the Dio instance with default options
      _dio.options.contentType = 'application/json';
    }
  }

  @override
  Future<CommonState.CommonState> updateUserStatusMessage({required String newStatusMessage}) async {

    const api = 'user/statusMessage';
    const url = '$baseUrl$api';

    try {
      final response = await _dio.patch(url, queryParameters: {'newStatusMessage': newStatusMessage});

      if (response.statusCode == 200) {
        final state = CommonState.Success();

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return CommonState.Fail();
    } catch (e) {
      return CommonState.Fail();
    }
  }

}