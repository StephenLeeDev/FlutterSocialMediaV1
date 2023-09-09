import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/follow/follow_repository.dart';
import '../../constant/constant.dart';
import '../../model/common/single_integer_state.dart' as SingleIntegerState;
import '../../model/user/simple/list/simple_user_list_model.dart';
import '../../model/user/simple/list/simple_user_list_state.dart' as SimpleUserListState;

class FollowRepositoryImpl extends FollowRepository {

  final Dio _dio;

  FollowRepositoryImpl(this._dio);

  /// Start following the user by their email
  @override
  Future<SingleIntegerState.SingleIntegerState> startFollow({required String userEmail}) async {

    const api = 'follow';
    const url = '$baseUrl$api';

    try {
      final Response response = await _dio.post(url, queryParameters: {'following': userEmail});

      if (response.statusCode == 201) {
        final state = SingleIntegerState.Success.fromJson(response.data);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return SingleIntegerState.Fail();
    } catch (e) {
      return SingleIntegerState.Fail();
    }
  }

  /// Unfollow the user by their email
  @override
  Future<SingleIntegerState.SingleIntegerState> unFollow({required String userEmail}) async {

    final api = 'follow/following/cancel?email=$userEmail';
    final url = '$baseUrl$api';

    try {
      final Response response = await _dio.delete(url);

      if (response.statusCode == 200) {
        final state = SingleIntegerState.Success.fromJson(response.data);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return SingleIntegerState.Fail();
    } catch (e) {
      return SingleIntegerState.Fail();
    }
  }

  /// Get follower list
  @override
  Future<SimpleUserListState.SimpleUserListState> getFollowerList({required String email, required int page, required int limit}) async {

    const api = 'follow/follower';
    final url = '$baseUrl$api?email=$email&page=$page&limit=$limit';

    try {
      final Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        final simpleUserListModel = SimpleUserListModel.fromJson(response.data);
        final state = SimpleUserListState.Success(total: simpleUserListModel.total, list: simpleUserListModel.userList);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return SimpleUserListState.Fail();
    } catch (e) {
      return SimpleUserListState.Fail();
    }
  }

  /// Get following list
  @override
  Future<SimpleUserListState.SimpleUserListState> getFollowingList({required String email, required int page, required int limit}) async {

    const api = 'follow/following';
    final url = '$baseUrl$api?email=$email&page=$page&limit=$limit';

    try {
      final Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        final simpleUserListModel = SimpleUserListModel.fromJson(response.data);
        final state = SimpleUserListState.Success(total: simpleUserListModel.total, list: simpleUserListModel.userList);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return SimpleUserListState.Fail();
    } catch (e) {
      return SimpleUserListState.Fail();
    }
  }

}
