import 'package:flutter/foundation.dart';

import '../../../data/model/post/post_list_state.dart';
import '../../../data/model/post/post_model.dart';
import '../../../domain/usecase/post/get_post_list_usecase.dart';

class PostListViewModel extends ChangeNotifier {
  final GetPostListUseCase _getPostListUseCase;

  PostListViewModel({
    required GetPostListUseCase getPostListUseCase,
  }) : _getPostListUseCase = getPostListUseCase;

  /// Using to manage server communication state
  /// List UI rendering is through _currentList below
  PostListState _postListState = Ready();
  PostListState get postListState => _postListState;

  setPostListState({required PostListState postListState}) {
    _postListState = postListState;
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

  /// Total posts count can fetch
  bool _hasNext = true;
  bool get hasNext => _hasNext;

  setHasNext({required bool value}) {
    _hasNext = value;
  }

  /// List of posts fetched so far (Using for UI rendering)
  List<PostModel> _currentList = [];
  List<PostModel> get currentList => _currentList;

  setCurrentList({required List<PostModel> list}) {
    _currentList = list;
    notifyListeners();
  }

  /// Add additional posts to the _currentList
  addAdditionalList({required List<PostModel> additionalList}) {
    List<PostModel> copyList = List.from(currentList);
    copyList.addAll(additionalList);
    setCurrentList(list: copyList);
  }

  /// Fetch additional paginated posts from the application server
  Future<void> getPostList() async {
    if (postListState is Loading || !hasNext) return;
    setPostListState(postListState: Loading());

    final state = await _getPostListUseCase.execute(page: page, limit: limit);
    if (state is Success) {
      increasePage();
      debugPrint("state.total : ${state.total}");
      debugPrint("state.list : ${state.list}");

      addAdditionalList(additionalList: state.list);
      setPostListState(postListState: state);

      if (currentList.length >= state.total) setHasNext(value: false);
    }
  }

  /// Refresh the post list
  Future<void> refresh() async {
    setCurrentList(list: []);
    setPage(value: 1);
    setHasNext(value: true);

    getPostList();
  }

  /// Set updated post item's bookmark/unbookmark
  setUpdatedBookmark({required int postId}) {
    final index = currentList.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final list = currentList.toList();
      list[index].setBookmark();

      /// Not using 'setCurrentList()' because of avoiding updating of the total list
      _currentList = list;
    }
  }

  /// Set updated post item's like/unlike
  setUpdatedLike({required int postId, required int likeCount}) {
    final index = currentList.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final list = currentList.toList();
      list[index].setLike();
      list[index].setLikeCount(value: likeCount);

      /// Not using 'setCurrentList()' because of avoiding updating of the total list
      _currentList = list;
    }
  }

}