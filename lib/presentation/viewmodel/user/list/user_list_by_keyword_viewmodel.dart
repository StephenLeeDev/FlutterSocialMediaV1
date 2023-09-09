import 'package:flutter/foundation.dart';

import '../../../../data/model/user/simple/item/simple_user_info_model.dart';
import '../../../../data/model/user/simple/list/simple_user_list_state.dart';
import '../../../../domain/usecase/user/list/get_user_list_by_keyword_usecase.dart';

/// Fetch user list by keyword ViewModel
/// It handling fetching user list by keyword with calling the API[GetUserListByKeywordUseCase]
/// It searches users whose username contains the keyword
class UserListByKeywordViewModel {

  final GetUserListByKeywordUseCase _getUserListByKeywordUseCase;

  UserListByKeywordViewModel({
    required GetUserListByKeywordUseCase getUserListByKeywordUseCase,
  }) : _getUserListByKeywordUseCase = getUserListByKeywordUseCase;

  /// It represents user list state
  final ValueNotifier<SimpleUserListState> _userListState = ValueNotifier<SimpleUserListState>(Ready());
  ValueNotifier<SimpleUserListState> get userListStateNotifier => _userListState;
  SimpleUserListState get userListState => userListStateNotifier.value;

  _setUserListState({required SimpleUserListState state}) {
    _userListState.value = state;
  }

  /// The searching keyword
  /// It returns users whose username contains the keyword
  String _keyword = "";
  String get keyword => _keyword;

  setKeyword({required String value}) {
    _keyword = value;
    _reinitialize();
  }

  /// Fetch user list by keyword
  Future<void> getUserListByKeyword() async {
    if (userListState is Loading || !hasNext) return;
    _setUserListState(state: Loading());

    final state = await _getUserListByKeywordUseCase.execute(keyword: keyword, page: page, limit: limit);

    _setUserListState(state: state);

    if (state is Success) {
      increasePage();

      addAdditionalList(additionalList: state.list);

      if (currentList.length >= state.total) setHasNext(value: false);
    }
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

  /// Reinitialize
  void _reinitialize() {
    _setCurrentList(list: []);
    _setPage(value: 1);
    setHasNext(value: true);
  }

}