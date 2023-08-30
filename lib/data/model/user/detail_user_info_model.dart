import 'simple_user_info.dart';

class DetailUserInfoModel extends SimpleUserInfo {
  String? statusMessage;
  bool? isFollowing;
  int? followerCount;
  int? followingCount;

  DetailUserInfoModel({
    String? email,
    String? username,
    String? thumbnail,
    this.statusMessage,
    this.isFollowing,
    this.followerCount,
    this.followingCount,
  }) : super(email: email, username: username, thumbnail: thumbnail);

  factory DetailUserInfoModel.fromJson(Map<String, dynamic> json) {
    return DetailUserInfoModel(
      email: json['email'],
      username: json['username'],
      thumbnail: json['thumbnail'],
      statusMessage: json['statusMessage'],
      isFollowing: json['isFollowing'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['statusMessage'] = statusMessage;
    data['isFollowing'] = isFollowing;
    data['followerCount'] = followerCount;
    data['followingCount'] = followingCount;
    return data;
  }

  @override
  String toString() {
    return 'DetailUserInfoModel(email: $email, username: $username, thumbnail: $thumbnail, statusMessage: $statusMessage, isFollowing: $isFollowing, followerCount: $followerCount, followingCount: $followingCount)';
  }
}