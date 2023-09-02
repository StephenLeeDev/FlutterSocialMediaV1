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
  int? followers;
  int get getFollowers => followers ?? 0;
  int? followings;
  int get getFollowings => followings ?? 0;

  MyUserInfo({
    this.email,
    this.username,
    this.thumbnail,
    this.bookMarks,
    this.statusMessage,
    this.totalPostCount,
    this.followers,
    this.followings,
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
      followers: json['followers'],
      followings: json['followings'],
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
      'followers': followers,
      'followings': followings,
    };
  }

  MyUserInfo copyWith({
    String? email,
    String? username,
    String? thumbnail,
    List<int>? bookMarks,
    String? statusMessage,
    int? totalPostCount,
    int? followers,
    int? followings,
  }) {
    return MyUserInfo(
      email: email ?? this.email,
      username: username ?? this.username,
      thumbnail: thumbnail ?? this.thumbnail,
      bookMarks: bookMarks ?? this.bookMarks,
      statusMessage: statusMessage ?? this.statusMessage,
      totalPostCount: totalPostCount ?? this.totalPostCount,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
    );
  }

  @override
  String toString() {
    return 'MyUserInfo(email: $email, username: $username, thumbnail: $thumbnail, bookMarks: $bookMarks, statusMessage: $statusMessage, totalPostCount: $totalPostCount, followers: $followers, followings: $followings)';
  }
}
