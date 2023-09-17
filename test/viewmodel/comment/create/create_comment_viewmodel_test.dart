import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/comment/item/comment_item_state.dart';
import 'package:flutter_social_media_v1/data/model/comment/item/comment_model.dart';
import 'package:flutter_social_media_v1/data/repository/comment/comment_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/comment/create/create_comment_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/comment/create/create_comment_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final viewModel = CreateCommentViewModel(createCommentUseCase: CreateCommentUseCase(commentRepository: CommentRepositoryImpl(Dio())));

  const testString1 = "UnitTest";
  const testString2 = "Flutter";

  group("setCommentItemState", () {
    test("Set Ready", () {
      viewModel.setCommentItemState(createCommentState: Ready());
      expect(viewModel.createCommentState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setCommentItemState(createCommentState: Loading());
      expect(viewModel.createCommentState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setCommentItemState(createCommentState: Fail());
      expect(viewModel.createCommentState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setCommentItemState(createCommentState: Success(item: CommentModel()));
      expect(viewModel.createCommentState is Success, true);
    });
  });

  group("setPostId", () {
    test("Set postId", () {
      viewModel.setPostId(value: 1);
      expect(viewModel.postId, 1);

      viewModel.setPostId(value: 100);
      expect(viewModel.postId, 100);
    });
  });

  group("setParentCommentId", () {
    test("Set parentCommentId", () {
      viewModel.setParentCommentId(value: 1);
      expect(viewModel.parentCommentId, 1);

      viewModel.setParentCommentId(value: 100);
      expect(viewModel.parentCommentId, 100);
    });
  });

  group("setParentCommentAuthor", () {
    test("Set parentCommentAuthor", () {

      viewModel.setParentCommentAuthor(value: testString1);
      expect(viewModel.parentCommentAuthor, testString1);

      viewModel.setParentCommentAuthor(value: testString2);
      expect(viewModel.parentCommentAuthor, testString2);
    });
  });

  group("setContent", () {
    test("Set content", () {

      viewModel.setContent(value: testString1);
      expect(viewModel.content, testString1);

      viewModel.setContent(value: testString2);
      expect(viewModel.content, testString2);
    });
  });

  group("_setIsValid & _checkIsValid", () {
    test("Set isValid & check isValid", () {
      viewModel.setPostId(value: -1);
      viewModel.setContent(value: "");
      viewModel.setParentCommentId(value: null);
      viewModel.setParentCommentAuthor(value: null);
      expect(viewModel.isValid, false);

      viewModel.setPostId(value: 1);
      viewModel.setContent(value: "");
      expect(viewModel.isValid, false);

      viewModel.setContent(value: testString1);
      expect(viewModel.isValid, true);

      viewModel.setParentCommentId(value: 1);
      viewModel.setParentCommentAuthor(value: testString2);
      expect(viewModel.isValid, true);

      viewModel.setPostId(value: -1);
      expect(viewModel.isValid, false);

      viewModel.setPostId(value: 1);
      viewModel.setContent(value: "");
      expect(viewModel.isValid, false);

      viewModel.setPostId(value: 100);
      viewModel.setContent(value: testString2);
      expect(viewModel.isValid, true);
    });
  });

}
