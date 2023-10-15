import 'package:flutter/foundation.dart';

import '../../../../../data/model/dm/room/item/dm_room_item_state.dart';
import '../../../../../domain/usecase/dm/room/create_dm_room_usecase.dart';

/// This ViewModel is responsible for handling the new DM room creation
class CreateDmRoomViewModel {
  final CreateDmRoomUseCase _createDmRoomUseCase;

  CreateDmRoomViewModel({
    required CreateDmRoomUseCase createDmRoomUseCase,
  }) : _createDmRoomUseCase = createDmRoomUseCase;

  /// UI state
  /// Create DM room state
  final ValueNotifier<DmRoomItemState> _createDmRoomState = ValueNotifier<DmRoomItemState>(Ready());
  ValueNotifier<DmRoomItemState> get createDmRoomStateNotifier => _createDmRoomState;
  DmRoomItemState get createDmRoomState => createDmRoomStateNotifier.value;

  setCreateDmRoomState({required DmRoomItemState state}) {
    _createDmRoomState.value = state;
  }

  /// Execute create the new DM room API
  Future<DmRoomItemState> createDmRoom({required String receiverEmail}) async {
    setCreateDmRoomState(state: Loading());

    final state = await _createDmRoomUseCase.execute(receiverEmail: receiverEmail);
    setCreateDmRoomState(state: state);
    return state;
  }

}