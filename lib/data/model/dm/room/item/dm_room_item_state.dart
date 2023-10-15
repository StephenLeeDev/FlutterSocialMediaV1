import 'dm_room_model.dart';

abstract class DmRoomItemState {}

class Ready extends DmRoomItemState {}

class Loading extends DmRoomItemState {}

class Fail extends DmRoomItemState {}

class Success extends DmRoomItemState {
  late DmRoomModel item;
  Success({required this.item});
}