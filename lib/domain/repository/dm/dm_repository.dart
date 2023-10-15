import '../../../data/model/dm/room/item/dm_room_item_state.dart';
import '../../../data/model/dm/room/list/dm_room_list_state.dart';

abstract class DmRepository {
  Future<DmRoomItemState> createDmRoom({required String receiverEmail});
  Future<DmRoomListState> getDmRoomList({required int page, required int limit});
}