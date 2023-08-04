import 'package:flutter/foundation.dart';

import '../../../../data/model/common/common_state.dart';
import '../../../../domain/usecase/post/delete/delete_post_usecase.dart';

/// This ViewModel is responsible for handling the deletion of post
class DeletePostViewModel {
  final DeletePostUseCase _deletePostUseCase;

  DeletePostViewModel({
    required DeletePostUseCase deletePostUseCase,
  }) : _deletePostUseCase = deletePostUseCase;

  /// Delete post state
  final ValueNotifier<CommonState> _deletePostState = ValueNotifier<CommonState>(Ready());
  ValueNotifier<CommonState> get deletePostStateNotifier => _deletePostState;
  CommonState get deletePostState => _deletePostState.value;

  setDeletePostState({required CommonState deletePostState}) {
    _deletePostState.value = deletePostState;
  }

  /// Delete post
  Future<CommonState> deletePost({required int postId}) async {
    setDeletePostState(deletePostState: Loading());

    return await _deletePostUseCase.execute(postId: postId);
  }
}