import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/repository/user/user_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/user/current_user/get_current_user_info_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/user/current_user/get_user_info/current_user_info_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final viewModel = CurrentUserInfoViewModel(getCurrentUserInfoUseCase: GetCurrentUserInfoUseCase(userRepository: UserRepositoryImpl(Dio())));

  const testString1 = "UnitTest";
  const testString2 = "Flutter";

  group("setStatusMessage", () {
    test("Set statusMessage", () {
      viewModel.setStatusMessage(statusMessage: testString1);
      expect(viewModel.statusMessage, testString1);

      viewModel.setStatusMessage(statusMessage: "");
      expect(viewModel.statusMessage, "");

      viewModel.setStatusMessage(statusMessage: testString2);
      expect(viewModel.statusMessage, testString2);
    });
  });

}