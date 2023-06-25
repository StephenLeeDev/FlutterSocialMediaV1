import '../../../data/model/common/common_state.dart';
import '../../repository/user/user_repository.dart';

class PostBookmarkUseCase {
  final UserRepository _userRepository;

  PostBookmarkUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  Future<CommonState> execute({required int postId}) async {
    return await _userRepository.postBookmark(postId: postId);
  }
}