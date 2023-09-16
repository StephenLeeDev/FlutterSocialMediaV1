import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/post/item/post_item_state.dart';
import 'package:flutter_social_media_v1/data/model/post/item/post_model.dart';
import 'package:flutter_social_media_v1/data/repository/post/post_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/post/update/update_post_description_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/update/update_post_description_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final viewModel = UpdatePostDescriptionViewModel(updatePostDescriptionUseCase: UpdatePostDescriptionUseCase(postRepository: PostRepositoryImpl(Dio())));

  group("setPostItemState", () {
    test("Set Ready", () {
      viewModel.setPostItemState(updatePostDescriptionState: Ready());
      expect(viewModel.updatePostDescriptionState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setPostItemState(updatePostDescriptionState: Loading());
      expect(viewModel.updatePostDescriptionState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setPostItemState(updatePostDescriptionState: Fail());
      expect(viewModel.updatePostDescriptionState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setPostItemState(updatePostDescriptionState: Success(item: PostModel()));
      expect(viewModel.updatePostDescriptionState is Success, true);
    });
  });

  group("setPostId", () {
    test("Set postId", () {
      expect(viewModel.postId, -1);

      viewModel.setPostId(value: 1);
      expect(viewModel.postId, 1);
    });
  });

  group("setPreviousDescription", () {
    test("Set previousDescription", () {
      viewModel.setPreviousDescription(value: "");
      expect(viewModel.previousDescription, "");

      const string = "UnitTest";
      viewModel.setPreviousDescription(value: string);
      expect(viewModel.previousDescription, string);
    });
  });

  group("setDescription", () {
    test("Set description", () {
      viewModel.setDescription(value: "");
      expect(viewModel.description, "");

      const string = "UnitTest";
      viewModel.setDescription(value: string);
      expect(viewModel.description, string);
    });
  });

  group("_setIsValid & _checkIsValid", () {
    test("Set isValid & check isValid", () {
      const string = "UnitTest";

      viewModel.setPostItemState(updatePostDescriptionState: Ready());
      viewModel.setPreviousDescription(value: "");
      viewModel.setDescription(value: "");
      expect(viewModel.isValid, false);

      viewModel.setPreviousDescription(value: string);
      expect(viewModel.isValid, false);

      viewModel.setDescription(value: string);
      expect(viewModel.isValid, false);

      viewModel.setDescription(value: "$string Flutter");
      expect(viewModel.isValid, true);

      viewModel.setPostItemState(updatePostDescriptionState: Loading());
      expect(viewModel.isValid, false);

      viewModel.setPostItemState(updatePostDescriptionState: Ready());
      viewModel.setDescription(value: "");
      expect(viewModel.isValid, false);
    });
  });

}