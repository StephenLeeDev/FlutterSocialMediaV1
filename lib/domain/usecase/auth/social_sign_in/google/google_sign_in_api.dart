import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  /// Sign in
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      var user = await GoogleSignIn().signIn();
      if (user != null) {
        debugPrint('googleSignIn');
        debugPrint(user.displayName);
        debugPrint(user.email);
        debugPrint(user.id);
        debugPrint(user.serverAuthCode);
        debugPrint(user.photoUrl);

        return user;
      }
    } catch (e) {
      debugPrint('googleSignIn error : ${e.toString()}');
    }
    return null;
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      debugPrint('Google Sign Out successful');
    } catch (e) {
      debugPrint('Google Sign Out error: ${e.toString()}');
    }
  }
}