import 'package:flutter/foundation.dart';

import '../../../data/model/comment/create/create_comment_model.dart';
import '../../../data/model/comment/create/create_comment_state.dart';
import '../../../domain/usecase/comment/create_comment_usecase.dart';

/// This ViewModel is responsible for handling the creation of new comments/replies
class CreateCommentViewModel extends ChangeNotifier {
  final CreateCommentUseCase _createCommentUseCase;

  CreateCommentViewModel({
    required CreateCommentUseCase createCommentUseCase,
  }) : _createCommentUseCase = createCommentUseCase;

  /// ID of the post to fetch
  int _postId = -1;
  int get postId => _postId;

  setPostId({required int value}) {
    _postId = value;
  }

  /// The ID of the parent comment for this reply
  /// It's null when create comment, not reply
  int? _parentCommentId;
  int? get parentCommentId => _parentCommentId;

  setParentCommentId({required int value}) {
    _parentCommentId = value;
  }

  /// The email of the parent comment's author for this reply
  /// It's null when create comment, not reply
  String? _parentCommentAuthor;
  String? get parentCommentAuthor => _parentCommentAuthor;

  setParentCommentAuthor({required String value}) {
    _parentCommentAuthor = value;
  }

  /// Content
  String _content = "";
  String get content => _content;

  setContent({required String value}) {
    _content = value;
    checkIsValid();
  }

  checkIsValid() {
    final valid = postId > 0 && content.isNotEmpty;
    setIsValid(value: valid);
  }

  /// It represents whether comments/replies can be created
  bool _isValid = false;
  bool get isValid => _isValid;

  setIsValid({required bool value}) {
    _isValid = value;
    notifyListeners();
  }

  /// Using to manage server communication state
  CreateCommentState _createCommentState = Ready();
  CreateCommentState get createCommentState => _createCommentState;

  setCreateCommentState({required CreateCommentState createCommentState}) {
    _createCommentState = createCommentState;
  }

  Future<CreateCommentState> createComment() async {
    final CreateCommentModel createCommentModel = CreateCommentModel(
      postId: postId,
      content: content,
      parentCommentId: parentCommentId,
      parentCommentAuthor: parentCommentAuthor,
    );
    return await _createCommentUseCase.execute(createCommentModel: createCommentModel);
  }

}