import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/user/simple/item/simple_user_info_model.dart';
import 'package:flutter_social_media_v1/data/repository/follow/follow_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/follow/get_follower_list_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/follow/get_following_list_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/follow/list/follow_list_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

main() {

  final followRepository = FollowRepositoryImpl(Dio());
  final viewModel = FollowListViewModel(
    getFollowerListUseCase: GetFollowerListUseCase(followRepository: followRepository),
    getFollowingListUseCase: GetFollowingListUseCase(followRepository: followRepository),
  );

  const emailOne = "testUserOne@gmail.com";
  const emailTwo = "testUserTwo@gmail.com";

  group("setEmail", () {
    test("Set email", () {
      viewModel.setEmail(value: emailOne);
      expect(viewModel.email, emailOne);

      viewModel.setEmail(value: emailTwo);
      expect(viewModel.email, emailTwo);
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
      viewModel.addAdditionalList(additionalList: [SimpleUserInfoModel(email: emailOne)]);
      expect(viewModel.currentList.last.getEmail, emailOne);
      expect(viewModel.currentList.length, 1);

      viewModel.addAdditionalList(additionalList: [SimpleUserInfoModel(email: emailTwo)]);
      expect(viewModel.currentList.last.getEmail, emailTwo);
      expect(viewModel.currentList.length, 2);
    });
  });

}