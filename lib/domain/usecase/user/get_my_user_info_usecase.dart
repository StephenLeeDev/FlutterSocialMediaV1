import 'package:flutter_social_media_v1/data/model/user/my_user_info_state.dart';

import '../../repository/user/user_repository.dart';

class GetMyUserInfoUseCase {
  final UserRepository _userRepository;

  GetMyUserInfoUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<MyUserInfoState> execute() async {
    return await _userRepository.getMyUserInfo();
  }
}