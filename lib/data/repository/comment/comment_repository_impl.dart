import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/comment/comment_repository.dart';
import '../../constant/constant.dart';
import '../../model/comment/item/comment_model.dart';
import '../../model/comment/list/comment_list_model.dart';
import '../../model/comment/list/comment_list_state.dart' as CommentListState;
import '../../model/comment/create/create_comment_model.dart';
import '../../model/comment/create/create_comment_state.dart' as CreateCommentState;
import '../../model/common/common_state.dart' as CommonState;

class CommentRepositoryImpl extends CommentRepository {

  final Dio _dio;

  CommentRepositoryImpl(this._dio);

  @override
  Future<CommentListState.CommentListState> getCommentList({required int postId, required int page, required int limit}) async {

    const api = 'comment';
    final url = '$baseUrl$api?postId=$postId&page=$page&limit=$limit';

    try {
      final Response response = await _dio.get(url);

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

  @override
  Future<CommonState.CommonState> deleteComment({required int commentId}) async {

    final api = 'comment/$commentId';
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