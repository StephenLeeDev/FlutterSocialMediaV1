import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/comment/item/comment_model.dart';
import 'package:flutter_social_media_v1/data/model/comment/list/comment_list_state.dart';
import 'package:flutter_social_media_v1/data/model/user/simple/item/simple_user_info_model.dart';
import 'package:flutter_social_media_v1/data/repository/comment/comment_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/comment/list/get_comment_list_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/comment/list/comment_list_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final viewModel = CommentListViewModel(getCommentListUseCase: GetCommentListUseCase(commentRepository: CommentRepositoryImpl(Dio())));

  group("setCommentListState", () {
    test("Set Ready", () {
      viewModel.setCommentListState(commentListState: Ready());
      expect(viewModel.commentListState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setCommentListState(commentListState: Loading());
      expect(viewModel.commentListState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setCommentListState(commentListState: Fail());
      expect(viewModel.commentListState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setCommentListState(commentListState: Success(total: 0, list: []));
      expect(viewModel.commentListState is Success, true);
    });
  });

  group("setPostId", () {
    test("Set postId", () {
      expect(viewModel.postId, -1);
      viewModel.setPostId(value: 1);
      expect(viewModel.postId, 1);
    });
  });

  group("setParentComment", () {
    test("Set parentComment", () {
      expect(viewModel.parentComment, null);
      viewModel.setParentComment(commentModel: CommentModel(id: 1));
      expect(viewModel.parentComment?.commentId, 1);
    });
  });

  group("setMyEmail", () {
    test("Set myEmail", () {
      const email = "test@gmail.com";
      viewModel.setMyEmail(value: email);
      expect(viewModel.myEmail, email);
    });
  });

  group("increasePage", () {
    test("Increase page", () {
      final initialPage = viewModel.page;
      viewModel.increasePage();
      expect(viewModel.page, initialPage + 1);
    });
  });

  group("setHasNext", () {
    test("Set hasNext", () {
      viewModel.setHasNext(value: true);
      expect(viewModel.hasNext, true);

      viewModel.setHasNext(value: false);
      expect(viewModel.hasNext, false);
    });
  });

  group("setCurrentList", () {
    test("set currentList", () {
      viewModel.setCurrentList(list: []);
      expect(viewModel.currentList, []);

      viewModel.setCurrentList(list: [CommentModel(id: 1)]);
      expect(viewModel.currentList.length, 1);
      expect(viewModel.currentList.first.commentId, 1);
    });
  });

  group("addAdditionalList", () {
    test("Add additional list", () {
      viewModel.addAdditionalList(additionalList: [CommentModel(id: 1)]);
      expect(viewModel.currentList.last.commentId, 1);

      viewModel.addAdditionalList(additionalList: [CommentModel(id: 2)]);
      expect(viewModel.currentList.last.commentId, 2);
    });
  });

  group("prependNewItemToList", () {
    test("Prepend new item to the currentList", () {
      viewModel.reinitialize();
      viewModel.prependNewListToCurrentList(additionalList: [CommentModel(id: 3)]);
      expect(viewModel.currentList.first.commentId, 3);

      viewModel.prependNewListToCurrentList(index: 1, additionalList: [CommentModel(id: 4)]);
      expect(viewModel.currentList.last.commentId, 4);
    });
  });

  group("replaceUpdatedItemFromList", () {
    test("Replace updated item from list", () {
      const String before = "before";
      const String after = "after";
      viewModel.prependNewListToCurrentList(additionalList: [CommentModel(id: 5, content: before)]);

      final comment = viewModel.currentList.first;
      comment.content = after;
      viewModel.replaceUpdatedItemFromList(updatedComment: comment);

      expect(viewModel.currentList.first.getContent, after);
    });
  });

  group("reinitialize", () {
    test("Reinitialize", () {
      viewModel.prependNewListToCurrentList(additionalList: [CommentModel(id: 6)]);
      viewModel.setHasNext(value: false);

      viewModel.reinitialize();

      expect(viewModel.currentList.isEmpty, true);
      expect(viewModel.hasNext, true);
    });
  });

  group("setIsMineStatusAndReturn", () {
    test("Set isMine status and return", () {
      const String emailOne = "test1@gmail.com";
      const String emailTwo = "test2@gmail.com";

      viewModel.setMyEmail(value: emailOne);

      viewModel.prependNewListToCurrentList(additionalList: [CommentModel(id: 7, user: SimpleUserInfoModel(email: emailTwo))]);
      viewModel.setIsMineStatusAndReturn(list: viewModel.currentList);
      expect(viewModel.currentList.first.isMine, false);

      final comment = viewModel.currentList.first;
      comment.user?.email = emailOne;

      viewModel.replaceUpdatedItemFromList(updatedComment: comment);
      viewModel.setIsMineStatusAndReturn(list: viewModel.currentList);
      expect(viewModel.currentList.first.isMine, true);
    });
  });

  group("removeDeletedCommentFromList", () {
    test("Remove deleted comment from list", () {
      viewModel.reinitialize();
      viewModel.addAdditionalList(additionalList: [CommentModel(id: 8), CommentModel(id: 9), CommentModel(id: 10)]);
      viewModel.removeDeletedItemFromList(commentId: 8);

      expect(viewModel.currentList.length, 2);

      final firstItemId = viewModel.currentList.first.commentId;
      expect(firstItemId, 9);

      final secondItemId = viewModel.currentList.last.commentId;
      expect(secondItemId, 10);
    });
  });

}
