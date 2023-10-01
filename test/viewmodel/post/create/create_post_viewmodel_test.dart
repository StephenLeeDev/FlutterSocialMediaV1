import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/post/item/post_item_state.dart';
import 'package:flutter_social_media_v1/data/model/post/item/post_model.dart';
import 'package:flutter_social_media_v1/data/repository/post/post_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/post/create/create_post_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/create/create_post_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  final viewModel = CreatePostViewModel(createPostUseCase: CreatePostUseCase(postRepository: PostRepositoryImpl(Dio())));

  group("setPostItemState", () {
    test("Set Ready", () {
      viewModel.setPostItemState(createPostState: Ready());
      expect(viewModel.createPostState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setPostItemState(createPostState: Loading());
      expect(viewModel.createPostState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setPostItemState(createPostState: Fail());
      expect(viewModel.createPostState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setPostItemState(createPostState: Success(item: PostModel()));
      expect(viewModel.createPostState is Success, true);
    });
  });

  group("addAdditionalImagesToList", () {
    test("Add additional images to list", () {
      viewModel.addAdditionalImagesToList(list: [XFile("")]);
      expect(viewModel.imageList.length, 1);

      viewModel.addAdditionalImagesToList(list: [XFile(""), XFile("")]);
      expect(viewModel.imageList.length, 3);
    });
  });

  group("removeImageFromListByIndex", () {
    test("Remove image from list by index", () {
      viewModel.addAdditionalImagesToList(list: [XFile(""), XFile(""), XFile("")]);

      while (viewModel.imageList.isNotEmpty) {
        viewModel.removeImageFromListByIndex(index: 0);
      }
      expect(viewModel.imageList.length, 0);
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

  /// It contains [_checkIsValid]'s unit test
  group("_setIsValid", () {
    test("Set isValid", () {
      viewModel.setDescription(value: "");
      expect(viewModel.isValid, false);

      const string = "UnitTest";
      viewModel.setDescription(value: string);
      expect(viewModel.isValid, true);
    });
  });

}
