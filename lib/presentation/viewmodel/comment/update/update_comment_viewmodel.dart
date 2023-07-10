import 'package:flutter/foundation.dart';

import '../../../../data/model/comment/item/comment_item_state.dart';
import '../../../../data/model/comment/update/update_comment_model.dart';
import '../../../../domain/usecase/comment/update/update_comment_usecase.dart';

/// This ViewModel is responsible for handling the updating of comments/replies
class UpdateCommentViewModel {
  final UpdateCommentUseCase _updateCommentUseCase;

  UpdateCommentViewModel({
    required UpdateCommentUseCase updateCommentUseCase,
  }) : _updateCommentUseCase = updateCommentUseCase;

  /// The comment item's ID to update
  int _commentId = -1;
  int get commentId => _commentId;

  setCommentId({required int value}) {
    _commentId = value;
  }

  /// Original content
  String _originalContent = "";
  String get originalContent => _originalContent;

  setOriginalContent({required String value}) {
    _originalContent = value;
  }

  /// Updated content
  final ValueNotifier<String> _updatedContent = ValueNotifier<String>("");
  ValueNotifier<String> get contentNotifier => _updatedContent;
  String get updatedContent => _updatedContent.value;

  setUpdatedContent({required String value}) {
    _updatedContent.value = value;
    checkIsValid();
  }

  checkIsValid() {
    final valid = commentId > 0 && updatedContent.isNotEmpty && originalContent != updatedContent && updateCommentState is! Loading;
    setIsValid(value: valid);
  }

  /// It represents whether comments/replies can be updated
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isValidNotifier => _isValid;
  bool get isValid => _isValid.value;

  setIsValid({required bool value}) {
    _isValid.value = value;
  }

  /// It represents state
  final ValueNotifier<CommentItemState> _updateCommentState = ValueNotifier<CommentItemState>(Ready());
  ValueNotifier<CommentItemState> get updateCommentStateNotifier => _updateCommentState;
  CommentItemState get updateCommentState => _updateCommentState.value;

  setCommentItemState({required CommentItemState updateCommentState}) {
    _updateCommentState.value = updateCommentState;
  }

  /// Execute update comment API
  Future<CommentItemState> updateComment() async {
    setCommentItemState(updateCommentState: Loading());
    final UpdateCommentModel updateCommentModel = UpdateCommentModel(
      id: commentId,
      content: updatedContent,
    );

    final state = await _updateCommentUseCase.execute(updateCommentModel: updateCommentModel);
    setCommentItemState(updateCommentState: state);
    return state;
  }

  /// Initialize states after success/cancel task
  initUpdateStatus() {
    setCommentItemState(updateCommentState: Ready());
    setCommentId(value: -1);
    setOriginalContent(value: "");
    setUpdatedContent(value: "");
  }

}