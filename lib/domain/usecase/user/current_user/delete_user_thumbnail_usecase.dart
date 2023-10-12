import '../../../../data/model/common/single_string_state.dart';
import '../../../repository/user/user_repository.dart';

class DeleteUserThumbnailUseCase {
  final UserRepository _userRepository;

  DeleteUserThumbnailUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<SingleStringState> execute() async {
    return await _userRepository.deleteUserThumbnail();
  }
}