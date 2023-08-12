class MyUserInfo {
  String? email;
  String get getEmail => email ?? "Unknown";
  String? username;
  String get getUserName => username ?? "Unknown";
  String? thumbnail;
  String get getUserThumbnail => thumbnail ?? "";
  List<int>? bookMarks;

  MyUserInfo({
    this.email,
    this.username,
    this.thumbnail,
    this.bookMarks,
  });

  factory MyUserInfo.fromJson(Map<String, dynamic> json) {
    List<int>? bookMarks = (json['bookMarks'] as List<dynamic>?)?.cast<int>();

    return MyUserInfo(
      email: json['email'],
      username: json['username'],
      thumbnail: json['thumbnail'],
      bookMarks: bookMarks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'thumbnail': thumbnail,
      'bookMarks': bookMarks,
    };
  }

  MyUserInfo copyWith({
    String? email,
    String? username,
    String? thumbnail,
    List<int>? bookMarks,
  }) {
    return MyUserInfo(
      email: email ?? this.email,
      username: username ?? this.username,
      thumbnail: thumbnail ?? this.thumbnail,
      bookMarks: bookMarks ?? this.bookMarks,
    );
  }

  @override
  String toString() {
    return 'MyUserInfo(email: $email, username: $username, thumbnail: $thumbnail, bookMarks: $bookMarks)';
  }
}
