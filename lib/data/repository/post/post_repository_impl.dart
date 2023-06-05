import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_social_media_v1/data/model/post/post_list_model.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/get_access_token_usecase.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/repository/post/post_repository.dart';
import '../../constant/constant.dart';
import '../../model/post/post_list_state.dart';

class PostRepositoryImpl extends PostRepository {

  final dio = Dio();

  @override
  Future<PostListState> getPostList({required int page, required int limit}) async {
    final accessToken = GetIt.I.get<GetAccessTokenUseCase>().execute();

    dio.options.headers = {
      // 'Authorization': "Bearer $accessToken"
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InN1cmltMDMxN0BnbWFpbC5jb20iLCJpYXQiOjE2ODU5NjU4NTQsImV4cCI6MTY4NzI3OTg1NH0.VR8Bj6vN3FJ7wo15Rdk4fCzlh3RHr8cauP6FW89qGUM',
    };

    const api = 'post';
    final url = '$baseUrl$api?page=$page&limit=$limit';

    debugPrint("url : $url");

    final response = await dio.get(url);

    if (response.statusCode == 200) {
      final postListModel = PostListModel.fromJson(response.data);
      final PostListState postState = Success(total: postListModel.total, list: postListModel.postList);

      debugPrint("authResponse : ${postState.toString()}");

      return postState;
    }
    return Fail();
  }

}