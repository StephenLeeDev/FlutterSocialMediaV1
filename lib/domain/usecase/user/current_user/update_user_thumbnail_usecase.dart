import 'package:dio/dio.dart';

import '../../../../data/model/common/single_string_state.dart';
import '../../../repository/user/user_repository.dart';

class UpdateUserThumbnailUseCase {
  final UserRepository _userRepository;

  UpdateUserThumbnailUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<SingleStringState> execute({required MultipartFile newThumbnail}) async {
    return await _userRepository.updateUserThumbnail(newThumbnail: newThumbnail);
  }
}