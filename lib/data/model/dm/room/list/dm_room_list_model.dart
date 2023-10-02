import '../item/dm_room_model.dart';

class DmRoomListModel {
  final List<DmRoomModel>? dmRoomList;
  List<DmRoomModel> get getDmRoomList => dmRoomList ?? [];

  final int? total;
  int get getTotal => total ?? 0;

  DmRoomListModel({this.dmRoomList, this.total});

  factory DmRoomListModel.fromJson(Map<String, dynamic> json) {
    return DmRoomListModel(
      dmRoomList: (json['list'] as List<dynamic>?)
          ?.map((e) => DmRoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dmRooms': dmRoomList?.map((dmRoom) => dmRoom.toJson()).toList(),
      'total': total,
    };
  }

  @override
  String toString() {
    return 'DmRoomListModel(dmRooms: $dmRoomList, total: $total)';
  }
}