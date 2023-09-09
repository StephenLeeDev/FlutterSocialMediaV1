import '../../../data/model/user/simple/list/simple_user_list_state.dart';
import '../../repository/follow/follow_repository.dart';

class GetFollowingListUseCase {
  final FollowRepository _followRepository;

  GetFollowingListUseCase({required FollowRepository followRepository})
      : _followRepository = followRepository;

  Future<SimpleUserListState> execute({required String email, required int page, required int limit}) async {
    return await _followRepository.getFollowingList(email: email, page: page, limit: limit);
  }

}