import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/post/post_repository.dart';
import '../../constant/constant.dart';
import '../../model/common/single_integer_state.dart' as SingleIntegerState;
import '../../model/post/post_list_model.dart';
import '../../model/post/post_list_state.dart' as PostListState;

class PostRepositoryImpl extends PostRepository {

  final Dio _dio;

  PostRepositoryImpl(this._dio);

  @override
  Future<PostListState.PostListState> getPostList({required int page, required int limit}) async {

    const api = 'post';
    final url = '$baseUrl$api?page=$page&limit=$limit';
    debugPrint("url : $url");

    final Response response = await _dio.get(url);
    debugPrint("response : ${response.toString()}");

    if (response.statusCode == 200) {
      final postListModel = PostListModel.fromJson(response.data);
      final state = PostListState.Success(total: postListModel.total, list: postListModel.postList);

      debugPrint("state : ${state.toString()}");

      return state;
    }
    return PostListState.Fail();
  }

  @override
  Future<SingleIntegerState.SingleIntegerState> postLike({required int postId}) async {

    const api = 'post/{postId}/like';
    const url = '$baseUrl$api';
    debugPrint("url : $url");

    final Response response = await _dio.post(url, queryParameters: {'postId': postId});
    debugPrint("response : ${response.toString()}");

    if (response.statusCode == 201) {
      final value = response.data['likeCount'];
      final state = SingleIntegerState.Success(value);

      debugPrint("state : ${state.toString()}");

      return state;
    }
    return SingleIntegerState.Fail();
  }

}