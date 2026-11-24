import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thin wrapper around the `google_sign_in` package.
///
/// Updated for google_sign_in 7.x (stage 0 "make it run"), which replaced
/// `GoogleSignIn().signIn()` with a single shared instance that must be
/// initialized once before use, and `authenticate()`, which throws (instead
/// of returning null) when the user cancels or sign-in fails.
///
/// NOTE: Google sign-in needs a Firebase / Google Cloud OAuth configuration
/// (GoogleService-Info.plist / google-services.json) that is not in the
/// repository yet. Until stage 2 (auth) sets it up again, this fails and the
/// debug-only "test login" on the auth screen is the way in.
class GoogleSignInApi {
  /// `initialize()` may only be called once per app run.
  static Future<void>? _initialization;

  static Future<void> _ensureInitialized() =>
      _initialization ??= GoogleSignIn.instance.initialize();

  /// Sign in. Returns `null` when the user cancels or sign-in fails.
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      await _ensureInitialized();
      final user = await GoogleSignIn.instance.authenticate();
      debugPrint('googleSignIn: ${user.displayName} ${user.email} ${user.id}');
      return user;
    } catch (e) {
      debugPrint('googleSignIn error : ${e.toString()}');
      return null;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await GoogleSignIn.instance.signOut();
      debugPrint('Google Sign Out successful');
    } catch (e) {
      debugPrint('Google Sign Out error: ${e.toString()}');
    }
  }
}
