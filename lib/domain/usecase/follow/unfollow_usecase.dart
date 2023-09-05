import '../../../data/model/common/common_state.dart';
import '../../repository/follow/follow_repository.dart';

class UnfollowUseCase {
  final FollowRepository _followRepository;

  UnfollowUseCase({required FollowRepository followRepository})
      : _followRepository = followRepository;

  Future<CommonState> execute({required String userEmail}) async {
    return await _followRepository.unFollow(userEmail: userEmail);
  }

}