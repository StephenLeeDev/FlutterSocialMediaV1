import '../../../../data/model/user/my_user_info_state.dart';
import '../../../repository/user/user_repository.dart';

class GetCurrentUserInfoUseCase {
  final UserRepository _userRepository;

  GetCurrentUserInfoUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  Future<MyUserInfoState> execute() async {
    return await _userRepository.getCurrentUserInfo();
  }
}