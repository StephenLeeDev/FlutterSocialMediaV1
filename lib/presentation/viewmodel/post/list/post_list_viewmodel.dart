import 'package:flutter/foundation.dart';

import '../../../../data/model/post/list/post_list_state.dart';
import '../../../../data/model/post/item/post_model.dart';
import '../../../../domain/usecase/post/list/get_post_list_usecase.dart';

class PostListViewModel {
  final GetPostListUseCase _getPostListUseCase;

  PostListViewModel({
    required GetPostListUseCase getPostListUseCase,
  }) : _getPostListUseCase = getPostListUseCase;

  /// Using to manage server communication state
  /// List UI rendering is through currentList below
  final ValueNotifier<PostListState> _postListState = ValueNotifier<PostListState>(Ready());
  ValueNotifier<PostListState> get postListStateNotifier => _postListState;
  PostListState get postListState => postListStateNotifier.value;

  setPostListState({required PostListState postListState}) {
    _postListState.value = postListState;
  }

  /// My email address
  String _myEmail = "";
  String get myEmail => _myEmail;

  setMyEmail({required String value}) {
    _myEmail = value;
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
  final ValueNotifier<List<PostModel>> _currentList = ValueNotifier<List<PostModel>>([]);
  ValueNotifier<List<PostModel>> get currentListNotifier => _currentList;
  List<PostModel> get currentList => _currentList.value;

  setCurrentList({required List<PostModel> list}) {
    _currentList.value = setIsMineStatusAndReturn(list: list);
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
    setPostListState(postListState: state);

    if (state is Success) {
      increasePage();

      addAdditionalList(additionalList: state.list);

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

      setCurrentList(list: list);
    }
  }

  /// Set updated post item's like/unlike
  setUpdatedLike({required int postId, required int likeCount}) {
    final index = currentList.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final list = currentList.toList();
      list[index].setLike();
      list[index].setLikeCount(value: likeCount);

      setCurrentList(list: list);
    }
  }

  /// Check is mine
  List<PostModel> setIsMineStatusAndReturn({required List<PostModel> list}) {
    final copyList = List.of(list);
    for (int i = 0; i < copyList.length; i++) {
      if (copyList[i].isMyPost(myEmail: myEmail)) copyList[i].isMine = true;
    }
    return copyList;
  }

  /// Remove delete post from the list by post ID
  void removeDeletedPostFromList({required int postId}) {
    List<PostModel> copyList = List.of(currentList);
    copyList.removeWhere((post) => post.id == postId);

    setCurrentList(list: copyList);
  }

}