import '../../../data/model/common/common_state.dart';
import '../../repository/user/user_repository.dart';

class UpdateUserStatusMessageUseCase {
  final UserRepository _userRepository;

  UpdateUserStatusMessageUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<CommonState> execute({required String newStatusMessage}) async {
    return await _userRepository.updateUserStatusMessage(newStatusMessage: newStatusMessage);
  }
}