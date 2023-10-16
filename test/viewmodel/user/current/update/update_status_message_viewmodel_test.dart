import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/common/common_state.dart';
import 'package:flutter_social_media_v1/data/repository/user/user_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/user/current_user/update_user_status_message_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/user/current_user/update/update_status_message_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

main() {

  final viewModel = UpdateUserStatusMessageViewModel(updateUserStatusMessageUseCase: UpdateUserStatusMessageUseCase(userRepository: UserRepositoryImpl(Dio())));

  const testString1 = "UnitTest";
  const testString2 = "Flutter";

  group("setUpdateStatusMessageState", () {
    test("Set Ready", () {
      viewModel.setUpdateStatusMessageState(Ready());
      expect(viewModel.updateStatusMessageState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setUpdateStatusMessageState(Loading());
      expect(viewModel.updateStatusMessageState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setUpdateStatusMessageState(Fail());
      expect(viewModel.updateStatusMessageState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setUpdateStatusMessageState(Success());
      expect(viewModel.updateStatusMessageState is Success, true);
    });
  });

  group("setPreviousStatusMessage", () {
    test("Set previousStatusMessage", () {
      expect(viewModel.previousStatusMessage, "");

      viewModel.setPreviousStatusMessage(testString1);
      expect(viewModel.previousStatusMessage, testString1);

      viewModel.setPreviousStatusMessage(testString2);
      expect(viewModel.previousStatusMessage, testString2);
    });
  });

  group("setNewStatusMessage", () {
    test("Set newStatusMessage", () {
      expect(viewModel.newStatusMessage, "");

      viewModel.setNewStatusMessage(testString1);
      expect(viewModel.newStatusMessage, testString1);

      viewModel.setNewStatusMessage(testString2);
      expect(viewModel.newStatusMessage, testString2);
    });
  });

  group("setIsValid & checkIsValid", () {
    test("Set isValid & check isValid", () {
      const string = "UnitTest";

      viewModel.setUpdateStatusMessageState(Ready());
      viewModel.setPreviousStatusMessage("");
      viewModel.setNewStatusMessage("");
      expect(viewModel.isValid, false);

      viewModel.setPreviousStatusMessage(string);
      expect(viewModel.isValid, false);

      viewModel.setNewStatusMessage(string);
      expect(viewModel.isValid, false);

      viewModel.setNewStatusMessage("$string Flutter");
      expect(viewModel.isValid, true);

      viewModel.setUpdateStatusMessageState(Loading());
      expect(viewModel.isValid, false);

      viewModel.setUpdateStatusMessageState(Ready());
      viewModel.setNewStatusMessage("");
      expect(viewModel.isValid, false);
    });
  });

  group("initUpdateStatus", () {
    test("Initialize the ViewModels states", () {
      viewModel.setUpdateStatusMessageState(Success());
      viewModel.setPreviousStatusMessage(testString1);
      viewModel.setNewStatusMessage(testString2);

      expect(viewModel.updateStatusMessageState is Success, true);
      expect(viewModel.previousStatusMessage, testString1);
      expect(viewModel.newStatusMessage, testString2);

      viewModel.initUpdateStatus();

      expect(viewModel.updateStatusMessageState is Ready, true);
      expect(viewModel.previousStatusMessage, "");
      expect(viewModel.newStatusMessage, "");
    });
  });

}