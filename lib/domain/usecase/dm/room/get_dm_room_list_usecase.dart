import '../../../../data/model/dm/room/list/dm_room_list_state.dart';
import '../../../repository/dm/dm_repository.dart';

class GetDmRoomListUseCase {
  final DmRepository _dmRepository;

  GetDmRoomListUseCase({required DmRepository dmRepository})
      : _dmRepository = dmRepository;

  Future<DmRoomListState> execute({required int page, required int limit}) async {
    return await _dmRepository.getDmRoomList(page: page, limit: limit);
  }

}