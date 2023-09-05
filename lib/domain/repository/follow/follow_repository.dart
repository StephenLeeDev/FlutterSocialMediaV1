import '../../../data/model/common/common_state.dart';

abstract class FollowRepository {
  Future<CommonState> startFollow({required String userEmail});
  Future<CommonState> unFollow({required String userEmail});
}