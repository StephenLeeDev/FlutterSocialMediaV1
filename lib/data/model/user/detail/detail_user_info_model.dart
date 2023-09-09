import '../simple/item/simple_user_info_model.dart';

class DetailUserInfoModel extends SimpleUserInfoModel {
  String? statusMessage;
  String get getStatusMessage => statusMessage ?? "";
  bool? isFollowing;
  bool get getIsFollowing => isFollowing ?? false;
  int? totalPostCount;
  int get getTotalPostCount => totalPostCount ?? 0;
  int? followerCount;
  int get getFollowerCount => followerCount ?? 0;
  int? followingCount;
  int get getFollowingCount => followingCount ?? 0;

  DetailUserInfoModel({
    String? email,
    String? username,
    String? thumbnail,
    this.statusMessage,
    this.isFollowing,
    this.totalPostCount,
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
      totalPostCount: json['totalPostCount'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['statusMessage'] = statusMessage;
    data['isFollowing'] = isFollowing;
    data['totalPostCount'] = totalPostCount;
    data['followerCount'] = followerCount;
    data['followingCount'] = followingCount;
    return data;
  }

  @override
  String toString() {
    return 'DetailUserInfoModel(email: $email, username: $username, thumbnail: $thumbnail, statusMessage: $statusMessage, isFollowing: $isFollowing, totalPostCount: $totalPostCount, followerCount: $followerCount, followingCount: $followingCount)';
  }
}