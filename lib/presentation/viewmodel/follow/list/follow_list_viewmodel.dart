import 'package:flutter/foundation.dart';

import '../../../../data/model/user/simple/item/simple_user_info_model.dart';
import '../../../../data/model/user/simple/list/simple_user_list_state.dart';
import '../../../../domain/usecase/follow/get_follower_list_usecase.dart';
import '../../../../domain/usecase/follow/get_following_list_usecase.dart';

/// Fetch follower/following user list ViewModel
/// It handling fetching follower user list with calling the follow API[GetFollowerListUseCase]
/// It handling fetching following user list with calling the unfollow API[UnfollowUseCase]
class FollowListViewModel {

  final GetFollowerListUseCase _getFollowerListUseCase;
  final GetFollowingListUseCase _getFollowingListUseCase;

  FollowListViewModel({
    required GetFollowerListUseCase getFollowerListUseCase,
    required GetFollowingListUseCase getFollowingListUseCase,
  }) : _getFollowerListUseCase = getFollowerListUseCase,
        _getFollowingListUseCase = getFollowingListUseCase;

  /// It represents user list state
  final ValueNotifier<SimpleUserListState> _followListState = ValueNotifier<SimpleUserListState>(Ready());
  ValueNotifier<SimpleUserListState> get followListStateNotifier => _followListState;
  SimpleUserListState get followListState => followListStateNotifier.value;

  _setFollowerListState({required SimpleUserListState state}) {
    _followListState.value = state;
  }

  /// Fetch followers/followings
  Future<void> getFollowList() async {
    if (followListState is Loading || !hasNext) return;
    _setFollowerListState(state: Loading());

    final state = isFollowerMode
      /// Fetch follower list
      ? await _getFollowerListUseCase.execute(email: email, page: page, limit: limit)
      /// Fetch following list
      : await _getFollowingListUseCase.execute(email: email, page: page, limit: limit);

    _setFollowerListState(state: state);

    if (state is Success) {
      increasePage();

      addAdditionalList(additionalList: state.list);

      if (currentList.length >= state.total) setHasNext(value: false);
    }
  }

  /// The user's email address to fetch
  String _email = "";
  String get email => _email;

  setEmail({required String value}) {
    _email = value;
  }

  /// When it's true, it works as a Follower list ViewModel
  /// When it's false, it works as a Following list ViewModel
  bool _isFollowerMode = true;
  bool get isFollowerMode => _isFollowerMode;

  setIsFollowing({required bool value}) {
    _isFollowerMode = value;
  }

  /// Page number to fetch
  int _page = 1;
  int get page => _page;

  increasePage() {
    _setPage(value: page + 1);
  }

  _setPage({required int value}) {
    _page = value;
  }

  /// The number of items to fetch at once
  int _limit = 10;
  int get limit => _limit;

  setLimit({required int value}) {
    _limit = value;
  }

  /// Total posts count can fetch
  bool _hasNext = true;
  bool get hasNext => _hasNext;

  setHasNext({required bool value}) {
    _hasNext = value;
  }

  /// The list fetched so far (Using for UI rendering)
  final ValueNotifier<List<SimpleUserInfoModel>> _currentList = ValueNotifier<List<SimpleUserInfoModel>>([]);
  ValueNotifier<List<SimpleUserInfoModel>> get currentListNotifier => _currentList;
  List<SimpleUserInfoModel> get currentList => _currentList.value;

  _setCurrentList({required List<SimpleUserInfoModel> list}) {
    _currentList.value = list;
  }

  /// Add additional list to the _currentList
  addAdditionalList({required List<SimpleUserInfoModel> additionalList}) {
    List<SimpleUserInfoModel> copyList = List.from(currentList);
    copyList.addAll(additionalList);
    _setCurrentList(list: copyList);
  }

  /// Refresh the states
  Future<void> refresh() async {
    _reinitialize();
    getFollowList();
  }

  /// Reinitialize
  void _reinitialize() {
    _setCurrentList(list: []);
    _setPage(value: 1);
    setHasNext(value: true);
  }

}