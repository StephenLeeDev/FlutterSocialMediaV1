class SimpleUserInfo {
  String? email;
  String get getEmail => email ?? "Unknown";
  String? username;
  String get getUserName => username ?? "Unknown";
  String? thumbnail;
  String get getThumbnail => thumbnail ?? "";

  SimpleUserInfo({
    this.email,
    this.username,
    this.thumbnail,
  });

  factory SimpleUserInfo.fromJson(Map<String, dynamic> json) {
    return SimpleUserInfo(
      email: json['email'],
      username: json['username'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'thumbnail': thumbnail,
    };
  }

  @override
  String toString() {
    return 'SimpleUserInfo(email: $email, username: $username, thumbnail: $thumbnail)';
  }
}
