import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/post/post_repository.dart';
import '../../constant/constant.dart';
import '../../model/common/single_integer_state.dart' as SingleIntegerState;
import '../../model/post/create/create_post_model.dart';
import '../../model/post/item/post_item_state.dart' as PostItemState;
import '../../model/post/item/post_model.dart';
import '../../model/post/list/post_list_model.dart';
import '../../model/post/list/post_list_state.dart' as PostListState;
import '../../model/common/common_state.dart' as CommonState;
import '../../model/post/update/update_post_description_model.dart';

class PostRepositoryImpl extends PostRepository {

  final Dio _dio;

  PostRepositoryImpl(this._dio);

  /// Create a new post
  @override
  Future<PostItemState.PostItemState> createPost({required CreatePostModel createPostModel}) async {

    const api = 'post';
    const url = '$baseUrl$api';

    _dio.options.contentType = 'multipart/form-data';

    final formData = FormData.fromMap({
      'description': createPostModel.description,
      'files': createPostModel.images,
    });

    try {
      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 201) {
        final postModel = PostModel.fromJson(response.data);
        final state = PostItemState.Success(item: postModel);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return PostItemState.Fail();
    } catch (e) {
      return PostItemState.Fail();
    } finally {
      /// Initialize the Dio instance with default options
      _dio.options.contentType = 'application/json';
    }
  }

  /// Get all user's post list
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

  /// Get current user's post list
  @override
  Future<PostListState.PostListState> getCurrentUserPostList({required int page, required int limit}) async {

    const api = 'post/my';
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

  /// Get current user's post list
  @override
  Future<PostListState.PostListState> getPostListByUserEmail({required int page, required int limit, required String email}) async {

    const api = 'post/user';
    final url = '$baseUrl$api?page=$page&limit=$limit&email=$email';

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

  /// Update post's description
  @override
  Future<PostItemState.PostItemState> updatePostDescription({required UpdatePostDescriptionModel updatePostDescriptionModel}) async {

    const api = "post/description";
    const url = "$baseUrl$api";

    try {
      final Response response = await _dio.patch(url, data: updatePostDescriptionModel.toJson());

      if (response.statusCode == 200) {
        final state = PostItemState.Success(item: PostModel.fromJson(response.data));

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return PostItemState.Fail();
    } catch (e) {
      return PostItemState.Fail();
    }
  }

  /// Like/unlike the post
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

  /// Delete a post by ID
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