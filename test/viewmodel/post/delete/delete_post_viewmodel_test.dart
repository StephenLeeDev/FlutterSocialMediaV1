import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/common/common_state.dart';
import 'package:flutter_social_media_v1/data/repository/post/post_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/post/delete/delete_post_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/delete/delete_post_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final viewModel = DeletePostViewModel(deletePostUseCase: DeletePostUseCase(postRepository: PostRepositoryImpl(Dio())));

  group("setDeletePostState", () {
    test("Set Ready", () {
      viewModel.setDeletePostState(deletePostState: Ready());
      expect(viewModel.deletePostState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setDeletePostState(deletePostState: Loading());
      expect(viewModel.deletePostState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setDeletePostState(deletePostState: Fail());
      expect(viewModel.deletePostState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setDeletePostState(deletePostState: Success());
      expect(viewModel.deletePostState is Success, true);
    });
  });

}