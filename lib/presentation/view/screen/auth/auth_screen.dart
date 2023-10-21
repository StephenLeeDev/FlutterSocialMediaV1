import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/model/auth/auth_request.dart';
import '../../../../data/model/auth/auth_state.dart';
import '../../../../domain/usecase/auth/post_sign_in_usecase.dart';
import '../../../../domain/usecase/auth/set_access_token_usecase.dart';
import '../../../../domain/usecase/auth/social_sign_in/google/google_sign_in_api.dart';
import '../../../util/snackbar/snackbar_util.dart';
import '../../../values/text/text.dart';
import '../../../viewmodel/auth/auth_viewmodel.dart';
import '../../widget/auth/social_sign_in_button_widget.dart';
import '../feed/feed_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const String routeName = "auth";
  static const String routeURL = "/auth";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final authViewModel = AuthViewModel(
    postSignInUseCase: GetIt.instance<PostSignInUseCase>(),
    setAccessTokenUseCase: GetIt.instance<SetAccessTokenUseCase>(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// Logo
            Image(
              width: MediaQuery.of(context).size.width / 2,
              image: const AssetImage("assets/image/logo_white.png"),
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 50),
            /// Google
            SocialSignInButtonWidget(
              title: continueWithGoogle,
              image: "assets/icon/google.svg",
              listener: () {
                googleSignIn(context: context);
              },
            ),
            // /// Facebook
            // SocialSignInButtonWidget(
            //   title: continueWithFacebook,
            //   image: "assets/icon/facebook.svg",
            //   listener: () {
            //     // TODO : Implement Facebook sign in
            //   },
            // ),
            // /// Apple
            // if (Platform.isIOS)
            //   SocialSignInButtonWidget(
            //     title: continueWithApple,
            //     image: "assets/icon/apple.svg",
            //     listener: () {
            //       // TODO : Implement Apple sign in
            //     },
            //   ),
          ],
        ),
      ),
    );
  }

  /// Google Sign in
  Future googleSignIn({required BuildContext context}) async {
    var user = await GoogleSignInApi.signIn();
    if (user != null) {

      AuthRequest authRequest = AuthRequest(email: user.email, username: user.displayName ?? "Unknown", socialType: "GOOGLE");
      if (context.mounted) {
        /// Try to sign-in
        await authViewModel.signIn(authRequest: authRequest);

        final authState = authViewModel.authState;
        /// Authenticated successfully
        if (authState is Success) {
          /// Move to the main screen
          if (context.mounted) context.go(FeedScreen.routeURL);
        }
        /// Fail to authenticate
        else if (authState is Fail) {
          if (context.mounted) showSnackBar(context: context, text: somethingWentWrongPleaseTryAgain);
        }
      }
    } else {
      if (context.mounted) showSnackBar(context: context, text: somethingWentWrongPleaseTryAgain);
    }
  }

  /// Facebook Sign in
  Future facebookSignIn({required BuildContext context}) async {
    // TODO : Implement Facebook SignUp/SignIn feature
  }
}
