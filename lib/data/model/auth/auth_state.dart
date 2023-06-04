abstract class AuthState {}

class Loading extends AuthState {}

class Unauthorized extends AuthState {}

class Fail extends AuthState {}

class Success extends AuthState {
  final String _accessToken;
  Success(this._accessToken);

  String get getAccessToken => _accessToken;
}
