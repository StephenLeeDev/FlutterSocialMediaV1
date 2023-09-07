import '../../../data/model/common/single_integer_state.dart';
import '../../repository/follow/follow_repository.dart';

class StartFollowUseCase {
  final FollowRepository _followRepository;

  StartFollowUseCase({required FollowRepository followRepository})
      : _followRepository = followRepository;

  Future<SingleIntegerState> execute({required String userEmail}) async {
    return await _followRepository.startFollow(userEmail: userEmail);
  }

}