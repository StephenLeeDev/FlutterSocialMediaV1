import 'package:dio/dio.dart';

import '../../../data/model/common/common_state.dart';
import '../../../data/model/common/single_string_state.dart';
import '../../../data/model/user/detail/detail_user_info_state.dart';
import '../../../data/model/user/my_user_info_state.dart';

abstract class UserRepository {
  Future<MyUserInfoState> getCurrentUserInfo();
  Future<DetailUserInfoState> getUserInfoByEmail({required String userEmail});
  Future<CommonState> postBookmark({required int postId});
  Future<SingleStringState> updateUserThumbnail({required MultipartFile newThumbnail});
  Future<CommonState> updateUserStatusMessage({required String newStatusMessage});
}