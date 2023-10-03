import 'package:flutter/foundation.dart';

import '../../../../../data/model/dm/room/item/dm_room_model.dart';
import '../../../../../data/model/dm/room/list/dm_room_list_state.dart';
import '../../../../../domain/usecase/dm/room/get_dm_room_list_usecase.dart';

/// This ViewModel is responsible for handling the fetching of DM room list
class DmRoomListViewModel {
  final GetDmRoomListUseCase _getDmRoomListUseCase;

  DmRoomListViewModel({
    required GetDmRoomListUseCase getDmRoomListUseCase,
  }) : _getDmRoomListUseCase = getDmRoomListUseCase;

  /// UI state
  /// List UI rendering is through _currentList below
  final ValueNotifier<DmRoomListState> _dmRoomListState = ValueNotifier<DmRoomListState>(Ready());
  ValueNotifier<DmRoomListState> get dmRoomListStateNotifier => _dmRoomListState;
  DmRoomListState get dmRoomListState => dmRoomListStateNotifier.value;

  setDmRoomListState({required DmRoomListState dmRoomListState}) {
    _dmRoomListState.value = dmRoomListState;
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
  final int _limit = 10;
  int get limit => _limit;

  /// It represents has next page
  bool _hasNext = true;
  bool get hasNext => _hasNext;

  setHasNext({required bool value}) {
    _hasNext = value;
  }

  /// List of DM rooms fetched so far (Using for UI rendering)
  final ValueNotifier<List<DmRoomModel>> _currentList = ValueNotifier<List<DmRoomModel>>([]);
  ValueNotifier<List<DmRoomModel>> get currentListNotifier => _currentList;
  List<DmRoomModel> get currentList => _currentList.value;

  setCurrentList({required List<DmRoomModel> list}) {
    _currentList.value = list;
  }

  /// Add additional dmRooms to the _currentList
  addAdditionalList({required List<DmRoomModel> additionalList}) {
    List<DmRoomModel> copyList = List.from(currentList);
    copyList.addAll(additionalList);
    setCurrentList(list: copyList);
  }

  /// Prepend a new dmRoom to the _currentList
  prependNewListToCurrentList({int index = 0, required List<DmRoomModel> additionalList}) {
    List<DmRoomModel> copyList = List.from(currentList);
    copyList.insertAll(index, additionalList);
    setCurrentList(list: copyList);
  }

  /// Fetch additional paginated dmRooms from the application server
  Future<void> getDmRoomList() async {
    if (dmRoomListState is Loading || !hasNext) return;
    setDmRoomListState(dmRoomListState: Loading());

    final state = await _getDmRoomListUseCase.execute(page: page, limit: limit);
    setDmRoomListState(dmRoomListState: state);

    if (state is Success) {
      increasePage();
      addAdditionalList(additionalList: state.getList);

      if (currentList.length >= state.total) setHasNext(value: false);
    }
  }

  /// Refresh the list
  Future<void> refresh() async {
    reinitialize();
    getDmRoomList();
  }

  /// Reinitialize
  void reinitialize() {
    setCurrentList(list: []);
    _setPage(value: 1);
    setHasNext(value: true);
  }

  /// Remove item from the currentList
  void removeItemFromListById({required int dmRoomId}) {
    List<DmRoomModel> copyList = List.of(currentList);
    copyList.removeWhere((dmRoom) => dmRoom.id == dmRoomId);

    setCurrentList(list: copyList);
  }

  bool isAlreadyExisting({required int dmRoomId}) {
    final room = currentList.where((dmRoom) => dmRoom.getRoomId == dmRoomId);
    return room.isNotEmpty ? true : false;
  }

}