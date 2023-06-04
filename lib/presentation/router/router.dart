import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecase/auth/get_access_token_use_case.dart';
import '../view/screen/auth/auth_screen.dart';
import '../view/screen/feed/feed_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: FeedScreen.routeURL,

  redirect: (context, state) async {
    String accessToken = await GetIt.instance<GetAccessTokenUseCase>().execute();
    debugPrint("accessToken : $accessToken");

    final isSignedIn = accessToken.isNotEmpty;
    if (!isSignedIn) {
      if (state.location != AuthScreen.routeURL) {
        return AuthScreen.routeURL;
      }
    }
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      name: AuthScreen.routeName,
      path: AuthScreen.routeURL,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      name: FeedScreen.routeName,
      path: FeedScreen.routeURL,
      builder: (context, state) => const FeedScreen(),
    ),
  ],
);
