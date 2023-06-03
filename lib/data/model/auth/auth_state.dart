abstract class AuthState {}

class Loading extends AuthState {}

class Unauthorized extends AuthState {}

class Fail extends AuthState {}

class Success extends AuthState {
  late String accessToken;
  Success(this.accessToken);

  String get getAccessToken => accessToken;
}
