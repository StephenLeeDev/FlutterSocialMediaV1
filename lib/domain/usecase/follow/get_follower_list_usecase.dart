import '../../../data/model/user/simple/list/simple_user_list_state.dart';
import '../../repository/follow/follow_repository.dart';

class GetFollowerListUseCase {
  final FollowRepository _followRepository;

  GetFollowerListUseCase({required FollowRepository followRepository})
      : _followRepository = followRepository;

  Future<SimpleUserListState> execute({required String email, required int page, required int limit}) async {
    return await _followRepository.getFollowerList(email: email, page: page, limit: limit);
  }

}