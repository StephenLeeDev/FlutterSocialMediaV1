import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/common/common_state.dart';
import 'package:flutter_social_media_v1/data/repository/user/user_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/user/current_user/post_bookmark_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/user/current_user/bookmark/bookmark_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final viewModel = BookmarkViewModel(postBookmarkUseCase: PostBookmarkUseCase(userRepository: UserRepositoryImpl(Dio())));

  group("setState", () {
    test("Set Ready", () {
      viewModel.setState(state: Ready());
      expect(viewModel.state is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setState(state: Loading());
      expect(viewModel.state is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setState(state: Fail());
      expect(viewModel.state is Fail, true);
    });

    test("Set Success", () {
      viewModel.setState(state: Success());
      expect(viewModel.state is Success, true);
    });
  });

}