import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/common/single_integer_state.dart';
import 'package:flutter_social_media_v1/data/repository/post/post_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/post/like/post_like_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/like/post_like_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final viewModel = PostLikeViewModel(postLikeUseCase: PostLikeUseCase(postRepository: PostRepositoryImpl(Dio())));

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
      viewModel.setState(state: Success(0));
      expect(viewModel.state is Success, true);
    });
  });

}