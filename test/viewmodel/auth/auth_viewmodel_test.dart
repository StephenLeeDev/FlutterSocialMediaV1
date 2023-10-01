import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/auth/auth_state.dart';
import 'package:flutter_social_media_v1/data/repository/auth/auth_repository_impl.dart';
import 'package:flutter_social_media_v1/data/repository/secure_storage/secure_storage_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/post_sign_in_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/set_access_token_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final viewModel = AuthViewModel(
    postSignInUseCase: PostSignInUseCase(authRepository: AuthRepositoryImpl(Dio())),
    setAccessTokenUseCase: SetAccessTokenUseCase(secureStorageRepository: SecureStorageRepositoryImpl())
  );

  const string = "UnitTest";

  group("setAuthState", () {
    test("Set Ready", () {
      viewModel.setAuthState(authState: Ready());
      expect(viewModel.authState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setAuthState(authState: Loading());
      expect(viewModel.authState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setAuthState(authState: Fail());
      expect(viewModel.authState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setAuthState(authState: Success(string));
      expect(viewModel.authState is Success, true);
    });
  });

}