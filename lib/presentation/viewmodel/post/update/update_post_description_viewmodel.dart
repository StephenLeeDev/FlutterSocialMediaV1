import 'package:flutter/foundation.dart';

import '../../../../data/model/post/item/post_item_state.dart';
import '../../../../data/model/post/update/update_post_description_model.dart';
import '../../../../domain/usecase/post/update/update_post_description_usecase.dart';

/// This ViewModel is responsible for handling the updating post's description
class UpdatePostDescriptionViewModel {
  final UpdatePostDescriptionUseCase _updatePostDescriptionUseCase;

  UpdatePostDescriptionViewModel({
    required UpdatePostDescriptionUseCase updatePostDescriptionUseCase,
  }) : _updatePostDescriptionUseCase = updatePostDescriptionUseCase;

  /// The post item's ID to update
  int _postId = -1;
  int get postId => _postId;

  setPostId({required int value}) {
    _postId = value;
  }

  /// It represents state
  final ValueNotifier<PostItemState> _updatePostDescriptionState = ValueNotifier<
      PostItemState>(Ready());

  ValueNotifier<PostItemState> get updatePostDescriptionStateNotifier => _updatePostDescriptionState;

  PostItemState get updatePostDescriptionState => _updatePostDescriptionState.value;

  setPostItemState({required PostItemState updatePostDescriptionState}) {
    _updatePostDescriptionState.value = updatePostDescriptionState;
  }

  /// Previous description
  String _previousDescription = "";
  String get previousDescription => _previousDescription;

  setPreviousDescription({required String value}) {
    _previousDescription = value;
  }

  /// Represents the currently edited description.
  final ValueNotifier<String> _description = ValueNotifier<String>("");
  ValueNotifier<String> get descriptionNotifier => _description;
  String get description => _description.value;

  setDescription({required String value}) {
    _description.value = value;
    _checkIsValid();
  }

  /// It represents whether a post can be updated
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isValidNotifier => _isValid;
  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    final valid = description.isNotEmpty && description != previousDescription && updatePostDescriptionState is! Loading;
    _setIsValid(value: valid);
  }

  /// Execute updating post's description API
  Future<PostItemState> updatePost() async {
    setPostItemState(updatePostDescriptionState: Loading());
    final UpdatePostDescriptionModel updatePostDescriptionModel = UpdatePostDescriptionModel(
      postId: postId,
      description: description,
    );

    final state = await _updatePostDescriptionUseCase.execute(updatePostDescriptionModel: updatePostDescriptionModel);
    setPostItemState(updatePostDescriptionState: state);
    return state;
  }

}