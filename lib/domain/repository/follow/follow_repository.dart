import '../../../data/model/common/single_integer_state.dart';

abstract class FollowRepository {
  Future<SingleIntegerState> startFollow({required String userEmail});
  Future<SingleIntegerState> unFollow({required String userEmail});
}