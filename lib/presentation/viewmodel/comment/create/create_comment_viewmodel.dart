import 'package:flutter/foundation.dart';

import '../../../../data/model/comment/create/create_comment_model.dart';
import '../../../../data/model/comment/item/comment_item_state.dart';
import '../../../../domain/usecase/comment/create/create_comment_usecase.dart';

/// This ViewModel is responsible for handling the creation of new comments/replies
class CreateCommentViewModel {
  final CreateCommentUseCase _createCommentUseCase;

  CreateCommentViewModel({
    required CreateCommentUseCase createCommentUseCase,
  }) : _createCommentUseCase = createCommentUseCase;

  /// ID of the post to fetch
  int _postId = -1;
  int get postId => _postId;

  setPostId({required int value}) {
    _postId = value;
    _checkIsValid();
  }

  /// The ID of the parent comment for this reply
  /// It's null when create comment, not reply
  int? _parentCommentId;
  int? get parentCommentId => _parentCommentId;

  setParentCommentId({required int? value}) {
    _parentCommentId = value;
  }

  /// The email of the parent comment's author for this reply
  /// It's null when create comment, not reply
  String? _parentCommentAuthor;
  String? get parentCommentAuthor => _parentCommentAuthor;

  setParentCommentAuthor({required String? value}) {
    _parentCommentAuthor = value;
  }

  /// Content
  final ValueNotifier<String> _content = ValueNotifier<String>("");
  ValueNotifier<String> get contentNotifier => _content;
  String get content => _content.value;

  setContent({required String value}) {
    _content.value = value;
    _checkIsValid();
  }

  _checkIsValid() {
    final valid = postId > 0 && content.isNotEmpty && createCommentState is! Loading;
    _setIsValid(value: valid);
  }

  /// It represents whether comments/replies can be created
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isValidNotifier => _isValid;
  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  /// It represents state
  final ValueNotifier<CommentItemState> _createCommentState = ValueNotifier<CommentItemState>(Ready());
  ValueNotifier<CommentItemState> get createCommentStateNotifier => _createCommentState;
  CommentItemState get createCommentState => _createCommentState.value;

  setCommentItemState({required CommentItemState createCommentState}) {
    _createCommentState.value = createCommentState;
    _checkIsValid();
  }

  /// Execute create comment API
  Future<CommentItemState> createComment() async {
    setCommentItemState(createCommentState: Loading());
    final CreateCommentModel createCommentModel = CreateCommentModel(
      postId: postId,
      content: content,
      parentCommentId: parentCommentId,
      parentCommentAuthor: parentCommentAuthor,
    );

    final state = await _createCommentUseCase.execute(createCommentModel: createCommentModel);
    setCommentItemState(createCommentState: state);
    return state;
  }

}