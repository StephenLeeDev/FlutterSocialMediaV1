import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/auth/auth_request.dart';
import '../../../../data/model/auth/auth_state.dart';
import '../../../../domain/usecase/auth/social_sign_in/google_sign_in_api.dart';
import '../../../util/snackbar/snackbar_util.dart';
import '../../../viewmodel/auth/auth_viewmodel.dart';
import '../feed/feed_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const String routeName = "auth";
  static const String routeURL = "/auth";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "AuthScreen",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          googleSignIn(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

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
