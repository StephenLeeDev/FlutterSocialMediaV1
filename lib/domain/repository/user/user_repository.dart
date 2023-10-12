import 'package:dio/dio.dart';

import '../../../data/model/common/common_state.dart';
import '../../../data/model/common/single_string_state.dart';
import '../../../data/model/user/detail/detail_user_info_state.dart';
import '../../../data/model/user/my_user_info_state.dart';
import '../../../data/model/user/simple/list/simple_user_list_state.dart';

abstract class UserRepository {
  Future<MyUserInfoState> getCurrentUserInfo();
  Future<DetailUserInfoState> getUserInfoByEmail({required String userEmail});
  Future<CommonState> postBookmark({required int postId});
  Future<SingleStringState> updateUserThumbnail({required MultipartFile newThumbnail});
  Future<SingleStringState> deleteUserThumbnail();
  Future<CommonState> updateUserStatusMessage({required String newStatusMessage});
  Future<SimpleUserListState> getUserListByKeyword({required String keyword, required int page, required int limit});
}