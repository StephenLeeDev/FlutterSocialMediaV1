class SimpleUserInfoModel {
  String? email;
  String get getEmail => email ?? "Unknown";
  String? username;
  String get getUserName => username ?? "Unknown";
  String? thumbnail;
  String get getThumbnail => thumbnail ?? "";
  String? statusMessage;
  String get getStatusMessage => statusMessage ?? "";

  SimpleUserInfoModel({
    this.email,
    this.username,
    this.thumbnail,
    this.statusMessage,
  });

  factory SimpleUserInfoModel.fromJson(Map<String, dynamic> json) {
    return SimpleUserInfoModel(
      email: json['email'],
      username: json['username'],
      thumbnail: json['thumbnail'],
      statusMessage: json['statusMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'thumbnail': thumbnail,
      'statusMessage': statusMessage,
    };
  }

  @override
  String toString() {
    return 'SimpleUserInfoModel(email: $email, username: $username, thumbnail: $thumbnail, statusMessage: $statusMessage)';
  }
}
