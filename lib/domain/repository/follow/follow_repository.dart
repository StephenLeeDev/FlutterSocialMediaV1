import '../../../data/model/common/single_integer_state.dart';
import '../../../data/model/user/simple/list/simple_user_list_state.dart';

abstract class FollowRepository {
  Future<SingleIntegerState> startFollow({required String userEmail});
  Future<SingleIntegerState> unFollow({required String userEmail});
  Future<SimpleUserListState> getFollowerList({required String email, required int page, required int limit});
  Future<SimpleUserListState> getFollowingList({required String email, required int page, required int limit});
}