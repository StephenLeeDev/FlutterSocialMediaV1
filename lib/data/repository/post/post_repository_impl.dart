import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_social_media_v1/data/model/post/post_list_model.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/get_access_token_usecase.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/repository/post/post_repository.dart';
import '../../constant/constant.dart';
import '../../model/post/post_list_state.dart';

class PostRepositoryImpl extends PostRepository {

  final Dio _dio;

  PostRepositoryImpl(this._dio);

  @override
  Future<PostListState> getPostList({required int page, required int limit}) async {

    const api = 'post';
    final url = '$baseUrl$api?page=$page&limit=$limit';

    debugPrint("url : $url");

    final Response response = await _dio.get(url);
    debugPrint("response : ${response.toString()}");

    if (response.statusCode == 200) {
      final postListModel = PostListModel.fromJson(response.data);
      final PostListState postState = Success(total: postListModel.total, list: postListModel.postList);

      debugPrint("authResponse : ${postState.toString()}");

      return postState;
    }
    return Fail();
  }

}