import 'package:flutter/foundation.dart';

import '../../../../data/model/comment/list/comment_list_state.dart';
import '../../../../data/model/comment/item/comment_model.dart';
import '../../../../domain/usecase/comment/list/get_comment_list_usecase.dart';

/// This ViewModel is responsible for handling the fetching of comments/replies
class CommentListViewModel {
  final GetCommentListUseCase _getCommentListUseCase;

  CommentListViewModel({
    required GetCommentListUseCase getCommentListUseCase,
  }) : _getCommentListUseCase = getCommentListUseCase;

  /// ID of the post to fetch
  int _postId = -1;
  int get postId => _postId;

  setPostId({required int value}) {
    _postId = value;
  }

  /// Replies' parent comment
  /// It's null on comment screen
  /// It's not null on reply screen
  CommentModel? _parentComment;
  CommentModel? get parentComment => _parentComment;

  setParentComment({required CommentModel? commentModel}) {
    _parentComment = commentModel;
  }

  /// My email address
  String _myEmail = "";
  String get myEmail => _myEmail;

  setMyEmail({required String value}) {
    _myEmail = value;
  }

  /// Using to manage server communication state
  /// List UI rendering is through _currentList below
  final ValueNotifier<CommentListState> _commentListState = ValueNotifier<CommentListState>(Ready());
  ValueNotifier<CommentListState> get commentListStateNotifier => _commentListState;
  CommentListState get commentListState => commentListStateNotifier.value;

  setCommentListState({required CommentListState commentListState}) {
    _commentListState.value = commentListState;
  }

  /// Page number to fetch
  int _page = 1;
  int get page => _page;

  increasePage() {
    setPage(value: page + 1);
  }

  setPage({required int value}) {
    _page = value;
  }

  /// The number of items to fetch at once
  final int _limit = 10;
  int get limit => _limit;

  /// It represents has next page
  bool _hasNext = true;
  bool get hasNext => _hasNext;

  setHasNext({required bool value}) {
    _hasNext = value;
  }

  /// List of comments fetched so far (Using for UI rendering)
  final ValueNotifier<List<CommentModel>> _currentList = ValueNotifier<List<CommentModel>>([]);
  ValueNotifier<List<CommentModel>> get currentListNotifier => _currentList;
  List<CommentModel> get currentList => _currentList.value;

  setCurrentList({required List<CommentModel> list}) {
    _currentList.value = setIsMineStatusAndReturn(list: list);
  }

  /// Add additional comments to the _currentList
  addAdditionalList({required List<CommentModel> additionalList}) {
    List<CommentModel> copyList = List.from(currentList);
    copyList.addAll(additionalList);
    setCurrentList(list: copyList);
  }

  /// Prepend a new comment to the _currentList
  prependNewListToCurrentList({int index = 0, required List<CommentModel> additionalList}) {
    List<CommentModel> copyList = List.from(currentList);
    copyList.insertAll(index, additionalList);
    setCurrentList(list: copyList);
  }

  /// Replace updated comment item from the _currentList
  replaceUpdatedItemFromList({required CommentModel updatedComment}) {
    int updatedIndex = currentList.indexWhere((item) => item.commentId == updatedComment.commentId);
    if (updatedIndex != -1) {
      List<CommentModel> copyList = List.from(currentList);
      copyList[updatedIndex] = updatedComment;
      setCurrentList(list: copyList);
    }
  }

  /// Fetch additional paginated comments from the application server
  Future<void> getCommentList() async {
    if (commentListState is Loading || !hasNext) return;
    setCommentListState(commentListState: Loading());

    final state = await _getCommentListUseCase.execute(postId: postId, parentCommentId: parentComment?.id, page: page, limit: limit);
    setCommentListState(commentListState: state);

    if (state is Success) {
      increasePage();
      addAdditionalList(additionalList: state.getList);

      if (currentList.length >= state.total) setHasNext(value: false);
    }
  }

  /// Refresh the list
  Future<void> refresh() async {
    reinitialize();

    if (parentComment != null) prependNewListToCurrentList(additionalList: [parentComment!]);
    getCommentList();
  }

  /// Reinitialize
  void reinitialize() {
    setCurrentList(list: []);
    setPage(value: 1);
    setHasNext(value: true);
  }

  /// Check is mine
  List<CommentModel> setIsMineStatusAndReturn({required List<CommentModel> list}) {
    final copyList = List.of(list);
    for (int i = 0; i < copyList.length; i++) {
      if (copyList[i].isMyComment(myEmail: myEmail)) copyList[i].isMine = true;
    }
    return copyList;
  }

  /// Remove delete comment from the list by comment ID
  void removeDeletedItemFromList({required int commentId}) {
    List<CommentModel> copyList = List.of(currentList);
    copyList.removeWhere((comment) => comment.id == commentId);

    setCurrentList(list: copyList);
  }

}