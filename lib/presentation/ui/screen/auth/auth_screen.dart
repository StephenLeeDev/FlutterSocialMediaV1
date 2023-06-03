import 'package:flutter/material.dart';
import 'package:flutter_social_media_v1/data/model/auth/auth_request.dart';
import 'package:flutter_social_media_v1/data/model/auth/auth_state.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../domain/usecase/auth/social_sign_in/google_sign_in_api.dart';
import '../../../util/snackbar/snackbar_util.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   _email,
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
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
        await context.read<AuthViewModel>().signIn(authRequest: authRequest);
        var state = context.read<AuthViewModel>().authState;
        if (state is Success) debugPrint("getAccessToken : ${state.getAccessToken}");
      }
    } else {
      if (context.mounted) showSnackBar(context: context, text: "It went something wrong.\nPlease try again.");
    }
  }
}
