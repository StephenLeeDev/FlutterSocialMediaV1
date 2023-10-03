import '../../../../data/model/dm/room/item/dm_room_item_state.dart';
import '../../../repository/dm/dm_repository.dart';

class CreateDmRoomUseCase {
  final DmRepository _dmRepository;

  CreateDmRoomUseCase({required DmRepository dmRepository})
      : _dmRepository = dmRepository;

  Future<DmRoomItemState> execute({required String receiverEmail}) async {
    return await _dmRepository.createDmRoom(receiverEmail: receiverEmail);
  }

}