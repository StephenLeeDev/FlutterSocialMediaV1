import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/follow/follow_repository.dart';
import '../../constant/constant.dart';
import '../../model/common/common_state.dart' as CommonState;

class FollowRepositoryImpl extends FollowRepository {

  final Dio _dio;

  FollowRepositoryImpl(this._dio);

  /// Start following the user by their email
  @override
  Future<CommonState.CommonState> startFollow({required String userEmail}) async {

    const api = 'follow';
    const url = '$baseUrl$api';

    try {
      final Response response = await _dio.post(url, queryParameters: {'following': userEmail});

      if (response.statusCode == 201) {
        final state = CommonState.Success();

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return CommonState.Fail();
    } catch (e) {
      return CommonState.Fail();
    }
  }

  /// Unfollow the user by their email
  @override
  Future<CommonState.CommonState> unFollow({required String userEmail}) async {

    final api = 'follow/following/cancel?email=$userEmail';
    final url = '$baseUrl$api';

    try {
      final Response response = await _dio.delete(url);

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
