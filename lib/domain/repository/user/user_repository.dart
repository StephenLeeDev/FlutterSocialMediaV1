import '../../../data/model/user/my_user_info_state.dart';

abstract class UserRepository {
  Future<MyUserInfoState> getMyUserInfo();
}