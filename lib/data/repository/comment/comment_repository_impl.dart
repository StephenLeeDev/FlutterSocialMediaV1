import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_social_media_v1/data/model/comment/item/comment_model.dart';

import '../../../domain/repository/comment/comment_repository.dart';
import '../../constant/constant.dart';
import '../../model/comment/list/comment_list_model.dart';
import '../../model/comment/list/comment_list_state.dart' as CommentListState;
import '../../model/comment/create/create_comment_model.dart';
import '../../model/comment/create/create_comment_state.dart' as CreateCommentState;

class CommentRepositoryImpl extends CommentRepository {

  final Dio _dio;

  CommentRepositoryImpl(this._dio);

  @override
  Future<CommentListState.CommentListState> getCommentList({required int postId, required int page, required int limit}) async {

    const api = 'comment';
    final url = '$baseUrl$api?postId=$postId&page=$page&limit=$limit';

    try {
      final Response response = await _dio.get(url);

      debugPrint("response.statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        final model = CommentListModel.fromJson(response.data);
        final state = CommentListState.Success(total: model.getTotal, list: model.getCommentList);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return CommentListState.Fail();
    } catch (e) {
      return CommentListState.Fail();
    }
  }

  @override
  Future<CreateCommentState.CreateCommentState> createComment({required CreateCommentModel createCommentModel}) async {

    const api = 'comment';
    const url = '$baseUrl$api';

    try {
      final Response response = await _dio.post(url, data: createCommentModel.toJson());

      if (response.statusCode == 201) {
        final model = CommentModel.fromJson(response.data);
        final state = CreateCommentState.Success(value: model);

        debugPrint("state : ${state.toString()}");

        return state;
      }
      return CreateCommentState.Fail();
    } catch (e) {
      return CreateCommentState.Fail();
    }
  }
}