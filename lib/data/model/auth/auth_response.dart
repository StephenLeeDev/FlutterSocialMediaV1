class AuthResponse {
  String accessToken;

  AuthResponse({
    required this.accessToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
    };
  }

  @override
  String toString() {
    return 'AuthResponse{accessToken: $accessToken}';
  }
}
