import 'package:flutter/foundation.dart';

import '../../../../data/model/common/common_state.dart';
import '../../../../domain/usecase/comment/delete/delete_comment_usecase.dart';

class DeleteCommentViewModel {
  final DeleteCommentUseCase _deleteCommentUseCase;

  DeleteCommentViewModel({
    required DeleteCommentUseCase deleteCommentUseCase,
  }) : _deleteCommentUseCase = deleteCommentUseCase;

  /// Delete comment state
  final ValueNotifier<CommonState> _deleteCommentState = ValueNotifier<CommonState>(Ready());
  ValueNotifier<CommonState> get deleteCommentStateNotifier => _deleteCommentState;
  CommonState get deleteCommentState => _deleteCommentState.value;

  setDeleteCommentState({required CommonState deleteCommentState}) {
    _deleteCommentState.value = deleteCommentState;
  }

  /// Delete comment
  Future<CommonState> deleteComment({required int commentId}) async {
    setDeleteCommentState(deleteCommentState: Loading());

    return await _deleteCommentUseCase.execute(commentId: commentId);
  }
}