import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/comment/item/comment_item_state.dart';
import 'package:flutter_social_media_v1/data/model/comment/item/comment_model.dart';
import 'package:flutter_social_media_v1/data/repository/comment/comment_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/comment/update/update_comment_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/comment/update/update_comment_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final viewModel = UpdateCommentViewModel(updateCommentUseCase: UpdateCommentUseCase(commentRepository: CommentRepositoryImpl(Dio())));

  const testString1 = "UnitTest";
  const testString2 = "Flutter";

  group("setCommentItemState", () {
    test("Set Ready", () {
      viewModel.setCommentItemState(updateCommentState: Ready());
      expect(viewModel.updateCommentState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setCommentItemState(updateCommentState: Loading());
      expect(viewModel.updateCommentState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setCommentItemState(updateCommentState: Fail());
      expect(viewModel.updateCommentState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setCommentItemState(updateCommentState: Success(item: CommentModel()));
      expect(viewModel.updateCommentState is Success, true);
    });
  });

  group("setCommentId", () {
    test("Set commentId", () {
      expect(viewModel.commentId, -1);

      viewModel.setCommentId(value: 1);
      expect(viewModel.commentId, 1);
    });
  });

  group("setOriginalContent", () {
    test("Set originalContent", () {
      viewModel.setOriginalContent(value: "");
      expect(viewModel.originalContent, "");

      viewModel.setOriginalContent(value: testString1);
      expect(viewModel.originalContent, testString1);
    });
  });

  group("setUpdatedContent", () {
    test("Set updatedContent", () {
      viewModel.setUpdatedContent(value: "");
      expect(viewModel.updatedContent, "");

      viewModel.setUpdatedContent(value: testString2);
      expect(viewModel.updatedContent, testString2);
    });
  });

  group("initUpdateStatus", () {
    test("Initialize updateStatus", () {
      viewModel.setCommentItemState(updateCommentState: Success(item: CommentModel()));
      viewModel.setCommentId(value: 1);
      viewModel.setOriginalContent(value: testString1);
      viewModel.setUpdatedContent(value: testString1);

      viewModel.initUpdateStatus();
      expect(viewModel.updateCommentState is Ready, true);
      expect(viewModel.commentId, -1);
      expect(viewModel.originalContent, "");
      expect(viewModel.updatedContent, "");
    });
  });

  group("_setIsValid & _checkIsValid", () {
    test("Set isValid & check isValid", () {
      viewModel.initUpdateStatus();

      viewModel.setCommentId(value: 1);
      expect(viewModel.isValid, false);

      viewModel.setOriginalContent(value: testString1);
      expect(viewModel.isValid, false);

      viewModel.setUpdatedContent(value: testString2);
      expect(viewModel.isValid, true);

      viewModel.setCommentItemState(updateCommentState: Loading());
      expect(viewModel.isValid, false);

      viewModel.setCommentItemState(updateCommentState: Ready());
      viewModel.setCommentId(value: -1);
      expect(viewModel.isValid, false);

      viewModel.setCommentId(value: 1);
      viewModel.setUpdatedContent(value: "");
      expect(viewModel.isValid, false);

      viewModel.setOriginalContent(value: testString1);
      viewModel.setUpdatedContent(value: testString1);
      expect(viewModel.isValid, false);
    });
  });

}