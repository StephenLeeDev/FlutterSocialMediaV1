import 'package:dio/dio.dart';

import '../../../data/model/common/common_state.dart';
import '../../../data/model/common/single_string_state.dart';
import '../../../data/model/user/my_user_info_state.dart';

abstract class UserRepository {
  Future<MyUserInfoState> getMyUserInfo();
  Future<CommonState> postBookmark({required int postId});
  Future<SingleStringState> updateUserThumbnail({required MultipartFile newThumbnail});
}