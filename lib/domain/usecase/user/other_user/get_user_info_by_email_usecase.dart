import '../../../../data/model/user/detail/detail_user_info_state.dart';
import '../../../repository/user/user_repository.dart';

class GetUserInfoByEmailUseCase {
  final UserRepository _userRepository;

  GetUserInfoByEmailUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  Future<DetailUserInfoState> execute({required String userEmail}) async {
    return await _userRepository.getUserInfoByEmail(userEmail: userEmail);
  }
}