import 'package:dio/dio.dart';

import '../../../domain/repository/dm/dm_repository.dart';
import '../../constant/constant.dart';
import '../../model/dm/room/item/dm_room_item_state.dart' as DmRoomItemState;
import '../../model/dm/room/item/dm_room_model.dart';
import '../../model/dm/room/list/dm_room_list_model.dart';
import '../../model/dm/room/list/dm_room_list_state.dart' as DmRoomListState;

class DmRepositoryImpl extends DmRepository {

  final Dio _dio;

  DmRepositoryImpl(this._dio);

  /// If a chat room with the receiver already exists, return the chat room information; if it doesn't exist, create and return the chat room
  @override
  Future<DmRoomItemState.DmRoomItemState> createDmRoom({required String receiverEmail}) async {

    const api = 'chat';
    const url = '$baseUrl$api';

    try {
      final Response response = await _dio.post(url, data: {'email': receiverEmail});

      if (response.statusCode == 201) {
        final state = DmRoomItemState.Success(item: DmRoomModel.fromJson(response.data));

        return state;
      }
      return DmRoomItemState.Fail();
    } catch (e) {
      return DmRoomItemState.Fail();
    }
  }

  @override
  Future<DmRoomListState.DmRoomListState> getDmRoomList({required int page, required int limit}) async {

    const api = 'chat';
    final url = '$baseUrl$api?page=$page&limit=$limit';

    try {
      final Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        final model = DmRoomListModel.fromJson(response.data);
        final state = DmRoomListState.Success(total: model.getTotal, list: model.getDmRoomList);

        return state;
      }
      return DmRoomListState.Fail();
    } catch (e) {
      return DmRoomListState.Fail();
    }
  }

}
