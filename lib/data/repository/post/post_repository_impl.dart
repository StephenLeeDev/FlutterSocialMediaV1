import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/post/post_repository.dart';
import '../../constant/constant.dart';
import '../../model/common/single_integer_state.dart' as SingleIntegerState;
import '../../model/post/list/post_list_model.dart';
import '../../model/post/list/post_list_state.dart' as PostListState;
import '../../model/common/common_state.dart' as CommonState;

class PostRepositoryImpl extends PostRepository {

  final Dio _dio;

  PostRepositoryImpl(this._dio);

  @override
  Future<PostListState.PostListState> getPostList({required int page, required int limit}) async {

    const api = 'post';
    final url = '$baseUrl$api?page=$page&limit=$limit';

    try {
      final Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        final postListModel = PostListModel.fromJson(response.data);
        final state = PostListState.Success(total: postListModel.total, list: postListModel.postList);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return PostListState.Fail();
    } catch (e) {
      return PostListState.Fail();
    }
  }

  @override
  Future<SingleIntegerState.SingleIntegerState> postLike({required int postId}) async {

    const api = 'post/{postId}/like';
    const url = '$baseUrl$api';

    try {
      final Response response = await _dio.post(url, queryParameters: {'postId': postId});

      if (response.statusCode == 201) {
        final value = response.data['likeCount'];
        final state = SingleIntegerState.Success(value);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return SingleIntegerState.Fail();
    } catch (e) {
      return SingleIntegerState.Fail();
    }
  }

  @override
  Future<CommonState.CommonState> deletePost({required int postId}) async {

    final api = 'post/$postId';
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