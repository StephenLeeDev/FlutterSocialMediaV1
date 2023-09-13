import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/post/item/post_model.dart';
import 'package:flutter_social_media_v1/data/model/post/list/post_list_state.dart';
import 'package:flutter_social_media_v1/data/model/user/simple/item/simple_user_info_model.dart';
import 'package:flutter_social_media_v1/data/repository/post/post_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/post/list/get_post_list_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/list/post_list_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final viewModel = PostListViewModel(getPostListUseCase: GetPostListUseCase(postRepository: PostRepositoryImpl(Dio())));

  group("setPostListState", () {
    test("Set Ready", () {
      viewModel.setPostListState(postListState: Ready());
      expect(viewModel.postListState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setPostListState(postListState: Loading());
      expect(viewModel.postListState is Loading, true);
    });

    test("Set MyUserInfoLoading", () {
      viewModel.setPostListState(postListState: MyUserInfoLoading());
      expect(viewModel.postListState is MyUserInfoLoading, true);
    });

    test("Set Fail", () {
      viewModel.setPostListState(postListState: Fail());
      expect(viewModel.postListState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setPostListState(postListState: Success(total: 0, list: []));
      expect(viewModel.postListState is Success, true);
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

  group("setLimit", () {
    test("Set limit", () {
      viewModel.setLimit(value: 5);
      expect(viewModel.limit, 5);
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

  group("addAdditionalList", () {
    test("Add additional list", () {
      viewModel.addAdditionalList(additionalList: [PostModel(id: 1)]);
      int lastIndex = viewModel.currentList.length - 1;
      expect(viewModel.currentList[lastIndex].getId, 1);

      viewModel.addAdditionalList(additionalList: [PostModel(id: 2)]);
      lastIndex = viewModel.currentList.length - 1;
      expect(viewModel.currentList[lastIndex].getId, 2);
    });
  });

  group("prependNewListToCurrentList", () {
    test("Prepend additional list", () {
      viewModel.prependNewListToCurrentList(additionalList: [PostModel(id: 3)]);
      expect(viewModel.currentList.first.getId, 3);

      viewModel.prependNewListToCurrentList(index: 1, additionalList: [PostModel(id: 4)]);
      expect(viewModel.currentList[1].getId, 4);
    });
  });

  group("replaceUpdatedItemFromList", () {
    test("Replace updated item from list", () {
      const String before = "before";
      const String after = "after";
      viewModel.prependNewListToCurrentList(additionalList: [PostModel(id: 5, description: before)]);

      final post = viewModel.currentList.first;
      post.description = after;
      viewModel.replaceUpdatedItemFromList(updatedPost: post);

      expect(viewModel.currentList.first.getDescription, after);
    });
  });

  group("reinitialize", () {
    test("Reinitialize", () {
      viewModel.prependNewListToCurrentList(additionalList: [PostModel(id: 6)]);
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

      viewModel.prependNewListToCurrentList(additionalList: [PostModel(id: 7, user: SimpleUserInfoModel(email: emailTwo))]);
      viewModel.setIsMineStatusAndReturn(list: viewModel.currentList);
      expect(viewModel.currentList.first.isMine, false);

      final post = viewModel.currentList.first;
      post.user?.email = emailOne;

      viewModel.replaceUpdatedItemFromList(updatedPost: post);
      viewModel.setIsMineStatusAndReturn(list: viewModel.currentList);
      expect(viewModel.currentList.first.isMine, true);
    });
  });

  group("removeDeletedPostFromList", () {
    test("Remove deleted post from list", () {
      viewModel.reinitialize();
      viewModel.addAdditionalList(additionalList: [PostModel(id: 8), PostModel(id: 9), PostModel(id: 10)]);
      viewModel.removeDeletedPostFromList(postId: 8);

      expect(viewModel.currentList.length, 2);

      final firstItemId = viewModel.currentList.first.getId;
      expect(firstItemId, 9);

      final secondItemId = viewModel.currentList[viewModel.currentList.length - 1].getId;
      expect(secondItemId, 10);
    });
  });

}
