class AuthRequest {
  String email;
  String username;
  String socialType;

  AuthRequest({
    required this.email,
    required this.username,
    required this.socialType,
  });

  factory AuthRequest.fromJson(Map<String, dynamic> json) {
    return AuthRequest(
      email: json['email'] as String,
      username: json['username'] as String,
      socialType: json['socialType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'socialType': socialType,
    };
  }

  @override
  String toString() {
    return 'AuthRequest{email: $email, username: $username, socialType: $socialType}';
  }

}
