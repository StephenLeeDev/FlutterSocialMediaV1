import '../item/dm_room_model.dart';

abstract class DmRoomListState {}

class Ready extends DmRoomListState {}

class Loading extends DmRoomListState {}

class Fail extends DmRoomListState {}

class Success extends DmRoomListState {
  final int total;
  late List<DmRoomModel> list;
  Success({required this.total, required this.list});

  int get getTotal => total;
  List<DmRoomModel> get getList => list;
}