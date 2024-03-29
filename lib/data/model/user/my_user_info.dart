class MyUserInfo {
  String? email;
  String get getEmail => email ?? "Unknown";
  String? username;
  String get getUserName => username ?? "Unknown";
  String? thumbnail;
  String get getUserThumbnail => thumbnail ?? "";
  List<int>? bookMarks;
  String? statusMessage;
  String get getStatusMessage => statusMessage ?? "";
  int? totalPostCount;
  int get getTotalPostCount => totalPostCount ?? 0;
  int? followerCount;
  int get getFollowers => followerCount ?? 0;
  int? followingCount;
  int get getFollowings => followingCount ?? 0;

  MyUserInfo({
    this.email,
    this.username,
    this.thumbnail,
    this.bookMarks,
    this.statusMessage,
    this.totalPostCount,
    this.followerCount,
    this.followingCount,
  });

  factory MyUserInfo.fromJson(Map<String, dynamic> json) {
    List<int>? bookMarks = (json['bookMarks'] as List<dynamic>?)?.cast<int>();

    return MyUserInfo(
      email: json['email'],
      username: json['username'],
      thumbnail: json['thumbnail'],
      bookMarks: bookMarks,
      statusMessage: json['statusMessage'],
      totalPostCount: json['totalPostCount'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'thumbnail': thumbnail,
      'bookMarks': bookMarks,
      'statusMessage': statusMessage,
      'totalPostCount': totalPostCount,
      'followerCount': followerCount,
      'followingCount': followingCount,
    };
  }

  MyUserInfo copyWith({
    String? email,
    String? username,
    String? thumbnail,
    List<int>? bookMarks,
    String? statusMessage,
    int? totalPostCount,
    int? followerCount,
    int? followingCount,
  }) {
    return MyUserInfo(
      email: email ?? this.email,
      username: username ?? this.username,
      thumbnail: thumbnail ?? this.thumbnail,
      bookMarks: bookMarks ?? this.bookMarks,
      statusMessage: statusMessage ?? this.statusMessage,
      totalPostCount: totalPostCount ?? this.totalPostCount,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
    );
  }

  @override
  String toString() {
    return 'MyUserInfo(email: $email, username: $username, thumbnail: $thumbnail, bookMarks: $bookMarks, statusMessage: $statusMessage, totalPostCount: $totalPostCount, followerCount: $followerCount, followingCount: $followingCount)';
  }
}
