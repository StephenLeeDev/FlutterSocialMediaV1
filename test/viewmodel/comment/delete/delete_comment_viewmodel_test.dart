import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/common/common_state.dart';
import 'package:flutter_social_media_v1/data/repository/comment/comment_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/comment/delete/delete_comment_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/comment/delete/delete_comment_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final viewModel = DeleteCommentViewModel(deleteCommentUseCase: DeleteCommentUseCase(commentRepository: CommentRepositoryImpl(Dio())));

  group("setDeleteCommentState", () {
    test("Set Ready", () {
      viewModel.setDeleteCommentState(deleteCommentState: Ready());
      expect(viewModel.deleteCommentState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setDeleteCommentState(deleteCommentState: Loading());
      expect(viewModel.deleteCommentState is Loading, true);
    });

    test("Set Unauthorized", () {
      viewModel.setDeleteCommentState(deleteCommentState: Unauthorized());
      expect(viewModel.deleteCommentState is Unauthorized, true);
    });

    test("Set Fail", () {
      viewModel.setDeleteCommentState(deleteCommentState: Fail());
      expect(viewModel.deleteCommentState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setDeleteCommentState(deleteCommentState: Success());
      expect(viewModel.deleteCommentState is Success, true);
    });
  });

}