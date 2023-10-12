import 'package:flutter/foundation.dart';

import '../../../../../data/model/common/single_string_state.dart';
import '../../../../../domain/usecase/user/current_user/delete_user_thumbnail_usecase.dart';

class DeleteUserThumbnailViewModel {
  final DeleteUserThumbnailUseCase _deleteUserThumbnailUseCase;

  DeleteUserThumbnailViewModel({
    required DeleteUserThumbnailUseCase deleteUserThumbnailUseCase,
  }) : _deleteUserThumbnailUseCase = deleteUserThumbnailUseCase;

  /// It represents state
  final ValueNotifier<SingleStringState> _deleteThumbnailState = ValueNotifier<SingleStringState>(Ready());
  ValueNotifier<SingleStringState> get deleteThumbnailStateNotifier => _deleteThumbnailState;
  SingleStringState get deleteThumbnailState => deleteThumbnailStateNotifier.value;

  setDeleteThumbnailState({required SingleStringState state}) {
    _deleteThumbnailState.value = state;
  }

  /// Execute API
  Future<SingleStringState> deleteThumbnail() async {
    setDeleteThumbnailState(state: Loading());

    final state = await _deleteUserThumbnailUseCase.execute();
    setDeleteThumbnailState(state: state);
    return state;
  }

}