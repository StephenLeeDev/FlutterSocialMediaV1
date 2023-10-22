import '../../../user/simple/item/simple_user_info_model.dart';

class DmRoomModel {
  final int? id;
  int get getRoomId => id ?? -1;
  final String? name;
  String get getRoomName => name ?? getPartnerName;
  final String? latestMessage;
  String get getLatestMessage => latestMessage ?? "";
  final List<String>? participants;
  final SimpleUserInfoModel? chatPartner;
  String get getPartnerName => chatPartner?.getUserName ?? "";
  String get getPartnerThumbnail => chatPartner?.getThumbnail ?? "";
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DmRoomModel({
    this.id,
    this.name,
    this.latestMessage,
    this.participants,
    this.chatPartner,
    this.createdAt,
    this.updatedAt,
  });

  factory DmRoomModel.fromJson(Map<String, dynamic> json) {
    return DmRoomModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      latestMessage: (json['latestMessage'] as String?) ?? "",
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      chatPartner: SimpleUserInfoModel.fromJson(json['chatPartner']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latestMessage': latestMessage,
      'participants': participants,
      'chatPartner': chatPartner,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DmRoomModel(id: $id, name: $name, latestMessage: $latestMessage, '
        'participants: $participants, chatPartner: $chatPartner, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  DmRoomModel copyWith({
    int? id,
    String? name,
    String? latestMessage,
    List<String>? participants,
    SimpleUserInfoModel? chatPartner,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DmRoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latestMessage: latestMessage ?? this.latestMessage,
      participants: participants ?? this.participants,
      chatPartner: chatPartner ?? this.chatPartner,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

}
