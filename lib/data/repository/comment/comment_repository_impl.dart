import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/comment/comment_repository.dart';
import '../../constant/constant.dart';
import '../../model/comment/comment_list_model.dart';
import '../../model/comment/comment_list_state.dart';

class CommentRepositoryImpl extends CommentRepository {

  final Dio _dio;

  CommentRepositoryImpl(this._dio);

  @override
  Future<CommentListState> getCommentList({required int postId, required int page, required int limit}) async {

    const api = 'comment';
    final url = '$baseUrl$api?postId=$postId&page=$page&limit=$limit';

    final Response response = await _dio.get(url);

    if (response.statusCode == 200) {
      final model = CommentListModel.fromJson(response.data);
      final state = Success(total: model.getTotal, list: model.getCommentList);

      debugPrint("state : ${state.toString()}");

      return state;
    }
    return Fail();
  }
}