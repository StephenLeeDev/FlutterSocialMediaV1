class UserModel {
  String? email;
  String? username;
  String? thumbnail;

  UserModel({
    required this.email,
    required this.username,
    required this.thumbnail,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
    return 'UserModel(email: $email, username: $username, thumbnail: $thumbnail)';
  }
}
