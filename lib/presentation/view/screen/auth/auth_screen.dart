import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/auth/auth_request.dart';
import '../../../../data/model/auth/auth_state.dart';
import '../../../../domain/usecase/auth/social_sign_in/google_sign_in_api.dart';
import '../../../util/snackbar/snackbar_util.dart';
import '../../../values/color/color.dart';
import '../../../values/text/text.dart';
import '../../../viewmodel/auth/auth_viewmodel.dart';
import '../../widget/auth/social_sign_in_button_widget.dart';
import '../feed/feed_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const String routeName = "auth";
  static const String routeURL = "/auth";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue00A7FF,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// Logo
            Image(
              width: MediaQuery.of(context).size.width / 2,
              image: const AssetImage("assets/image/logo.png"),
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
            /// Facebook
            SocialSignInButtonWidget(
              title: continueWithFacebook,
              image: "assets/icon/facebook.svg",
              listener: () {
                // TODO : Implement Facebook sign in
              },
            ),
            /// Apple
            if (Platform.isIOS)
              SocialSignInButtonWidget(
                title: continueWithApple,
                image: "assets/icon/apple.svg",
                listener: () {
                  // TODO : Implement Apple sign in
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Google Sign in
  Future googleSignIn({ required BuildContext context }) async {
    var user = await GoogleSignInApi.signIn();
    if (user != null) {

      AuthRequest authRequest = AuthRequest(email: user.email, username: user.displayName ?? "Unknown", socialType: "GOOGLE");
      if (context.mounted) {
        AuthViewModel authViewModel = context.read<AuthViewModel>();

        /// Try to sign-in
        await authViewModel.signIn(authRequest: authRequest);

        final authState = authViewModel.authState;
        if (authState is Success) { /// Authenticated successfully
          /// Move to the main screen
          if (context.mounted) context.go(FeedScreen.routeURL);
        } else if (authState is Fail) { /// Fail to authenticate
          if (context.mounted) showSnackBar(context: context, text: "Fail to authenticate.\nPlease try again.");
        }
      }
    } else {
      if (context.mounted) showSnackBar(context: context, text: "Something went wrong.\nPlease try again.");
    }
  }
}
