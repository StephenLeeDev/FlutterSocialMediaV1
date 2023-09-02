import 'detail_user_info_model.dart';

abstract class DetailUserInfoState {}

class Ready extends DetailUserInfoState {}

class Loading extends DetailUserInfoState {}

class Unauthorized extends DetailUserInfoState {}

class Fail extends DetailUserInfoState {}

class Success extends DetailUserInfoState {
  final DetailUserInfoModel _userInfo;
  Success(this._userInfo);

  DetailUserInfoModel get getUserInfo => _userInfo;
}
