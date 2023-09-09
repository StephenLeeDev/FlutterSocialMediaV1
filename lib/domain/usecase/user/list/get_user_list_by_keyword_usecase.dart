import '../../../../data/model/user/simple/list/simple_user_list_state.dart';
import '../../../repository/user/user_repository.dart';

class GetUserListByKeywordUseCase {
  final UserRepository _userRepository;

  GetUserListByKeywordUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<SimpleUserListState> execute({required String keyword, required int page, required int limit}) async {
    return await _userRepository.getUserListByKeyword(keyword: keyword, page: page, limit: limit);
  }

}