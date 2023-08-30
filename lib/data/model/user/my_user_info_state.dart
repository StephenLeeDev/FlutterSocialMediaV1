import 'my_user_info.dart';

abstract class MyUserInfoState {}

class Ready extends MyUserInfoState {}

class Loading extends MyUserInfoState {}

class Unauthorized extends MyUserInfoState {}

class Fail extends MyUserInfoState {}

class Success extends MyUserInfoState {
  final MyUserInfo _myUserInfo;
  Success(this._myUserInfo);

  MyUserInfo get getMyUserInfo => _myUserInfo;
}
