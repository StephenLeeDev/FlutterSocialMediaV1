import 'dart:io';

import 'package:flutter/foundation.dart';
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
            /// DEVELOPMENT ONLY: sign in without Google.
            /// `kDebugMode` is a compile-time constant, so this button (and
            /// its code) does not exist in release builds at all.
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextButton(
                  onPressed: () => testSignIn(context: context),
                  child: const Text(
                    'Test login (debug only)',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
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
      if (context.mounted) await signInToServer(context: context, authRequest: authRequest);
    } else {
      if (context.mounted) showSnackBar(context: context, text: somethingWentWrongPleaseTryAgain);
    }
  }

  /// DEVELOPMENT ONLY: signs in as the server's shared test account
  /// (testUser@gmail.com, the same account as POST /auth/test), skipping
  /// Google.
  ///
  /// Added in refactoring stage 0 because Google sign-in cannot work until a
  /// new Firebase / Google Cloud configuration exists (stage 2). It goes
  /// through exactly the same server sign-in as a real Google user, so the
  /// rest of the app behaves as usual.
  ///
  /// This works only because the server still trusts the email it receives
  /// (no Google ID-token check yet). Stage 2 fixes that on the server, and
  /// this shortcut must then switch to POST /auth/test or be removed.
  Future testSignIn({required BuildContext context}) async {
    final authRequest = AuthRequest(email: 'testUser@gmail.com', username: 'testUser', socialType: 'GOOGLE');
    await signInToServer(context: context, authRequest: authRequest);
  }

  /// Signs in to OUR server with the given account, then opens the feed.
  /// Shared by the Google sign-in and the debug test sign-in.
  Future signInToServer({required BuildContext context, required AuthRequest authRequest}) async {
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

  /// Facebook Sign in
  Future facebookSignIn({required BuildContext context}) async {
    // TODO : Implement Facebook SignUp/SignIn feature
  }
}
