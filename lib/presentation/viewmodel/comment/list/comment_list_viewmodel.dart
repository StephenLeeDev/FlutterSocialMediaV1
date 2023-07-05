import 'package:flutter/foundation.dart';

import '../../../../data/model/comment/list/comment_list_state.dart';
import '../../../../data/model/comment/item/comment_model.dart';
import '../../../../domain/usecase/comment/get_comment_list_usecase.dart';

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

  /// Using to manage server communication state
  /// List UI rendering is through _currentList below
  final ValueNotifier<CommentListState> _commentListState = ValueNotifier<CommentListState>(Ready());
  ValueNotifier<CommentListState> get commentListStateNotifier => _commentListState;

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

  /// Total comments count can fetch
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
    _currentList.value = list;
  }

  /// Add additional comments to the _currentList
  addAdditionalList({required List<CommentModel> additionalList}) {
    List<CommentModel> copyList = List.from(currentListNotifier.value);
    copyList.addAll(additionalList);
    setCurrentList(list: copyList);
  }

  /// Prepend a new comment to the _currentList
  prependNewCommentToList({required List<CommentModel> additionalList}) {
    List<CommentModel> copyList = List.from(currentListNotifier.value);
    copyList.insertAll(0, additionalList);
    setCurrentList(list: copyList);
  }

  /// Fetch additional paginated comments from the application server
  Future<void> getCommentList() async {
    if (commentListStateNotifier is Loading || !hasNext) return;
    setCommentListState(commentListState: Loading());

    final state = await _getCommentListUseCase.execute(postId: postId, page: page, limit: limit);
    setCommentListState(commentListState: state);

    if (state is Success) {
      increasePage();
      addAdditionalList(additionalList: state.getList);

      if (currentListNotifier.value.length >= state.total) setHasNext(value: false);
    }
  }

  /// Refresh the list
  Future<void> refresh() async {
    setCurrentList(list: []);
    setPage(value: 1);
    setHasNext(value: true);

    getCommentList();
  }

}