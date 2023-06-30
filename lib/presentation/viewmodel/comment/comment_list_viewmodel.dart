import 'package:flutter/foundation.dart';

import '../../../data/model/comment/comment_list_state.dart';
import '../../../data/model/comment/comment_model.dart';
import '../../../domain/usecase/comment/get_comment_list_usecase.dart';

class CommentListViewModel extends ChangeNotifier {
  final GetCommentListUseCase _getCommentListUseCase;

  CommentListViewModel({
    required GetCommentListUseCase getCommentListUseCase,
  }) : _getCommentListUseCase = getCommentListUseCase;

  /// ID of the post to fetch
  int _postId = 1;
  int get postId => _postId;

  setPostId({required int value}) {
    _postId = value;
  }

  /// Using to manage server communication state
  /// List UI rendering is through _currentList below
  CommentListState _commentListState = Ready();
  CommentListState get commentListState => _commentListState;

  setCommentListState({required CommentListState commentListState}) {
    _commentListState = commentListState;
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
  final int _limit = 3;
  int get limit => _limit;

  /// Total comments count can fetch
  bool _hasNext = true;
  bool get hasNext => _hasNext;

  setHasNext({required bool value}) {
    _hasNext = value;
  }

  /// List of comments fetched so far (Using for UI rendering)
  List<CommentModel> _currentList = [];
  List<CommentModel> get currentList => _currentList;

  setCurrentList({required List<CommentModel> list}) {
    _currentList = list;
    notifyListeners();
  }

  /// Add additional comments to the _currentList
  addAdditionalList({required List<CommentModel> additionalList}) {
    List<CommentModel> copyList = List.from(currentList);
    copyList.addAll(additionalList);
    setCurrentList(list: copyList);
  }

  /// Fetch additional paginated comments from the application server
  Future<void> getCommentList() async {
    if (commentListState is Loading || !hasNext) return;
    setCommentListState(commentListState: Loading());

    final state = await _getCommentListUseCase.execute(postId: postId, page: page, limit: limit);
    if (state is Success) {
      increasePage();

      addAdditionalList(additionalList: state.list);
      setCommentListState(commentListState: state);

      if (currentList.length >= state.total) setHasNext(value: false);
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