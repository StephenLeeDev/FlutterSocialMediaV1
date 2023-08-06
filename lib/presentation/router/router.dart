import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/comment/item/comment_model.dart';
import '../../domain/usecase/auth/get_access_token_usecase.dart';
import '../view/screen/auth/auth_screen.dart';
import '../view/screen/comment/comment/comment_screen.dart';
import '../view/screen/comment/reply/reply_screen.dart';
import '../view/screen/feed/feed_screen.dart';
import '../view/screen/main_navigation/main_navigation_screen.dart';
import '../view/screen/my/my_page_screen.dart';
import '../view/screen/notification/notification_screen.dart';
import '../view/screen/post/create/create_post_screen.dart';
import '../view/screen/search/search_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: FeedScreen.routeURL,

  redirect: (context, state) async {
    String accessToken = await GetIt.instance<GetAccessTokenUseCase>().execute();
    debugPrint("GoRouter accessToken : $accessToken");

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
      path: "/:tab(${FeedScreen.routeName}|${SearchScreen.routeName}|${NotificationScreen.routeName}|${MyPageScreen.routeName})",
      name: MainNavigationScreen.routeName,
      builder: (context, state) {
        final tab = state.pathParameters["tab"] ?? FeedScreen.routeName;
        return MainNavigationScreen(tab: tab);
      },
    ),
    GoRoute(
        name: CreatePostScreen.routeName,
        path: CreatePostScreen.routeURL,
        builder: (context, state) => const CreatePostScreen(),
    ),
    GoRoute(
      name: CommentScreen.routeName,
      path: CommentScreen.routeURL,
      builder: (context, state) {
        final postId = state.queryParameters['postId'] ?? "-1";
        return CommentScreen(postId: postId);
      }
    ),
    GoRoute(
        name: ReplyScreen.routeName,
        path: ReplyScreen.routeURL,
        builder: (context, state) {
          final postId = state.queryParameters['postId'] ?? "-1";
          final commentString = state.queryParameters[CommentModel().getSimpleName()] ?? "";
          return ReplyScreen(postId: postId, commentString: commentString);
        }
    ),
  ],
);