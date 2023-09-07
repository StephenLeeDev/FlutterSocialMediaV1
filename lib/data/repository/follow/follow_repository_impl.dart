import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/follow/follow_repository.dart';
import '../../constant/constant.dart';
import '../../model/common/single_integer_state.dart';

class FollowRepositoryImpl extends FollowRepository {

  final Dio _dio;

  FollowRepositoryImpl(this._dio);

  /// Start following the user by their email
  @override
  Future<SingleIntegerState> startFollow({required String userEmail}) async {

    const api = 'follow';
    const url = '$baseUrl$api';

    try {
      final Response response = await _dio.post(url, queryParameters: {'following': userEmail});

      if (response.statusCode == 201) {
        final state = Success.fromJson(response.data);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return Fail();
    } catch (e) {
      return Fail();
    }
  }

  /// Unfollow the user by their email
  @override
  Future<SingleIntegerState> unFollow({required String userEmail}) async {

    final api = 'follow/following/cancel?email=$userEmail';
    final url = '$baseUrl$api';

    try {
      final Response response = await _dio.delete(url);

      if (response.statusCode == 200) {
        final state = Success.fromJson(response.data);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return Fail();
    } catch (e) {
      return Fail();
    }
  }

}
