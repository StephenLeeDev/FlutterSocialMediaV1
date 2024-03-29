import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/user/user_repository.dart';
import '../../constant/constant.dart';
import '../../model/common/common_state.dart' as CommonState;
import '../../model/common/single_string_state.dart' as SingleStringState;
import '../../model/user/detail/detail_user_info_model.dart';
import '../../model/user/detail/detail_user_info_state.dart' as DetailUserInfoState;
import '../../model/user/my_user_info.dart';
import '../../model/user/my_user_info_state.dart' as MyUserInfoState;
import '../../model/user/simple/list/simple_user_list_model.dart';
import '../../model/user/simple/list/simple_user_list_state.dart' as SimpleUserListState;

class UserRepositoryImpl extends UserRepository {

  final Dio _dio;

  UserRepositoryImpl(this._dio);

  /// Get current user's detail information
  @override
  Future<MyUserInfoState.MyUserInfoState> getCurrentUserInfo() async {
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

  /// Get other user's detailed information by email
  /// it's not for current user
  /// If you want to get current user's information, use getMyUserInfo()
  @override
  Future<DetailUserInfoState.DetailUserInfoState> getUserInfoByEmail({required String userEmail}) async {
    const api = 'user/{userEmail}';
    const url = '$baseUrl$api';

    try {
      final Response response = await _dio.get(url, queryParameters: {'userEmail': userEmail});

      final code = response.statusCode;

      if (code == 200) {
        final state = DetailUserInfoState.Success(DetailUserInfoModel.fromJson(response.data));

        return state;
      }
      return DetailUserInfoState.Fail();
    } catch (e) {
      return DetailUserInfoState.Fail();
    }
  }

  /// Bookmark/Unbookmark a post
  @override
  Future<CommonState.CommonState> postBookmark({required int postId}) async {
    const api = 'user/post/bookmark';
    const url = '$baseUrl$api';

    final Response response = await _dio.post(url, data: {'postId': postId});

    try {
      final code = response.statusCode;

      if (code == 201) {
        final state = CommonState.Success();

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

  /// Update the current user's thumbnail
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

  /// Delete the current user's thumbnail
  @override
  Future<SingleStringState.SingleStringState> deleteUserThumbnail() async {
    const api = 'user/thumbnail';
    const url = '$baseUrl$api';

    try {
      final response = await _dio.delete(url);

      if (response.statusCode == 200) {
        final state = SingleStringState.Success(response.data['updatedThumbnail']);

        return state;
      }
      return SingleStringState.Fail();
    } catch (e) {
      return SingleStringState.Fail();
    }
  }

  /// Update the current user's status message
  @override
  Future<CommonState.CommonState> updateUserStatusMessage({required String newStatusMessage}) async {

    const api = 'user/statusMessage';
    const url = '$baseUrl$api';

    try {
      final response = await _dio.patch(url, data: {'statusMessage': newStatusMessage});

      if (response.statusCode == 200) {
        final state = CommonState.Success();

        return state;
      }
      return CommonState.Fail();
    } catch (e) {
      return CommonState.Fail();
    }
  }

  /// Get user list by keyword
  /// It returns users whose username contains the keyword
  @override
  Future<SimpleUserListState.SimpleUserListState> getUserListByKeyword({required String keyword, required int page, required int limit}) async {

    const api = 'user/search/users';
    final url = '$baseUrl$api?keyword=$keyword&page=$page&limit=$limit';

    try {
      final Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        final simpleUserListModel = SimpleUserListModel.fromJson(response.data);
        final state = SimpleUserListState.Success(total: simpleUserListModel.total, list: simpleUserListModel.userList);

        return state;
      }
      return SimpleUserListState.Fail();
    } catch (e) {
      return SimpleUserListState.Fail();
    }
  }

}