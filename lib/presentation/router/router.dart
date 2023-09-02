import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/comment/item/comment_model.dart';
import '../../data/model/post/item/post_model.dart';
import '../../domain/usecase/auth/get_access_token_usecase.dart';
import '../view/screen/auth/auth_screen.dart';
import '../view/screen/comment/comment/comment_screen.dart';
import '../view/screen/comment/reply/reply_screen.dart';
import '../view/screen/feed/feed_screen.dart';
import '../view/screen/feed/feed_screen_from_grid.dart';
import '../view/screen/main_navigation/main_navigation_screen.dart';
import '../view/screen/my/my_page_screen.dart';
import '../view/screen/notification/notification_screen.dart';
import '../view/screen/post/create/create_post_screen.dart';
import '../view/screen/post/update/update_post_description_screen.dart';
import '../view/screen/search/search_screen.dart';
import '../view/screen/user/user_detail_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: FeedScreen.routeURL,

  /// Default
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

    /// Authentication
    GoRoute(
      name: AuthScreen.routeName,
      path: AuthScreen.routeURL,
      builder: (context, state) => const AuthScreen(),
    ),

    /// Main tab
    GoRoute(
      path: "/:tab(${FeedScreen.routeName}|${SearchScreen.routeName}|${NotificationScreen.routeName}|${MyPageScreen.routeName})",
      name: MainNavigationScreen.routeName,
      builder: (context, state) {
        final tab = state.pathParameters["tab"] ?? FeedScreen.routeName;
        return MainNavigationScreen(tab: tab);
      },
    ),

    /// It's another feed screen called from grid list screen, just like Instagram's
    /// I separated it because it has little different features between FeedScreen
    // TODO : Might integrate both, but low priority
    GoRoute(
      name: FeedScreenFromGrid.routeName,
      path: FeedScreenFromGrid.routeURL,
      builder: (context, state) {
        /// Selected post's index from grid feed list screen
        final selectedIndexString = state.queryParameters['selectedIndex'];
        final selectedPostId = selectedIndexString == null ? -1 : int.parse(selectedIndexString);

        final title = state.queryParameters['title'] ?? "";
        final isFromMyPage = state.queryParameters['isFromMyPage'] ?? "true";

        return FeedScreenFromGrid(
          isFromMyPage: isFromMyPage == "true",
          selectedIndex: selectedPostId,
          title: title
        );
      },
    ),

    /// Create post
    GoRoute(
        name: CreatePostScreen.routeName,
        path: CreatePostScreen.routeURL,
        builder: (context, state) => const CreatePostScreen(),
    ),

    /// Update post description
    GoRoute(
      name: UpdatePostDescriptionScreen.routeName,
      path: UpdatePostDescriptionScreen.routeURL,
      builder: (context, state) {
        final postString = state.queryParameters[PostModel().getSimpleName()] ?? "";
        return UpdatePostDescriptionScreen(postString: postString);
      },
    ),

    /// Comment
    GoRoute(
      name: CommentScreen.routeName,
      path: CommentScreen.routeURL,
      builder: (context, state) {
        final postId = state.queryParameters['postId'] ?? "-1";
        return CommentScreen(postId: postId);
      }
    ),

    /// Reply
    GoRoute(
      name: ReplyScreen.routeName,
      path: ReplyScreen.routeURL,
      builder: (context, state) {
        final postId = state.queryParameters['postId'] ?? "-1";
        final commentString = state.queryParameters[CommentModel().getSimpleName()] ?? "";
        return ReplyScreen(postId: postId, commentString: commentString);
      },
    ),

    /// User detail
    GoRoute(
      name: UserDetailScreen.routeName,
      path: UserDetailScreen.routeURL,
      builder: (context, state) {
        final userEmail = state.queryParameters['userEmail'] ?? "";
        return UserDetailScreen(userEmail: userEmail);
      },
    ),

  ],
);