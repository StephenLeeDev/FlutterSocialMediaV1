import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/common/single_string_state.dart';
import 'package:flutter_social_media_v1/data/repository/user/user_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/user/current_user/delete_user_thumbnail_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/user/delete/delete_thumbnail_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final viewModel = DeleteUserThumbnailViewModel(deleteUserThumbnailUseCase: DeleteUserThumbnailUseCase(userRepository: UserRepositoryImpl(Dio())));

  const testString = "UnitTest";

  group("setDeleteThumbnailState", () {
    test("Set deleteThumbnailState", () {
      viewModel.setDeleteThumbnailState(state: Ready());
      expect(viewModel.deleteThumbnailState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setDeleteThumbnailState(state: Loading());
      expect(viewModel.deleteThumbnailState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setDeleteThumbnailState(state: Fail());
      expect(viewModel.deleteThumbnailState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setDeleteThumbnailState(state: Success(testString));
      expect(viewModel.deleteThumbnailState is Success, true);
      if (viewModel.deleteThumbnailState is Success) {
        final state = viewModel.deleteThumbnailState as Success;
        expect(state.getValue, testString);
      }
    });
  });

}