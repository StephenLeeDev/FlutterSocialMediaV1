import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/post/list/post_list_state.dart';
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

}
