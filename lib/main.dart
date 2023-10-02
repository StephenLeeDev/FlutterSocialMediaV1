import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';

import 'data/networking/dio_singleton.dart';
import 'data/networking/interceptor/token_interceptor.dart';
import 'data/repository/auth/auth_repository_impl.dart';
import 'data/repository/comment/comment_repository_impl.dart';
import 'data/repository/dm/dm_repository_impl.dart';
import 'data/repository/follow/follow_repository_impl.dart';
import 'data/repository/post/post_repository_impl.dart';
import 'data/repository/secure_storage/secure_storage_repository_impl.dart';
import 'data/repository/user/user_repository_impl.dart';
import 'domain/usecase/auth/get_access_token_usecase.dart';
import 'domain/usecase/auth/post_sign_in_usecase.dart';
import 'domain/usecase/auth/set_access_token_usecase.dart';
import 'domain/usecase/comment/create/create_comment_usecase.dart';
import 'domain/usecase/comment/delete/delete_comment_usecase.dart';
import 'domain/usecase/comment/list/get_comment_list_usecase.dart';
import 'domain/usecase/comment/update/update_comment_usecase.dart';
import 'domain/usecase/dm/room/create_dm_room_usecase.dart';
import 'domain/usecase/dm/room/get_dm_room_list_usecase.dart';
import 'domain/usecase/follow/get_follower_list_usecase.dart';
import 'domain/usecase/follow/get_following_list_usecase.dart';
import 'domain/usecase/follow/start_follow_usecase.dart';
import 'domain/usecase/follow/unfollow_usecase.dart';
import 'domain/usecase/post/create/create_post_usecase.dart';
import 'domain/usecase/post/delete/delete_post_usecase.dart';
import 'domain/usecase/post/list/get_current_user_post_list_usecase.dart';
import 'domain/usecase/post/list/get_post_list_by_user_email_usecase.dart';
import 'domain/usecase/post/list/get_post_list_usecase.dart';
import 'domain/usecase/post/like/post_like_usecase.dart';
import 'domain/usecase/post/update/update_post_description_usecase.dart';
import 'domain/usecase/user/current_user/get_current_user_info_usecase.dart';
import 'domain/usecase/user/list/get_user_list_by_keyword_usecase.dart';
import 'domain/usecase/user/other_user/get_user_info_by_email_usecase.dart';
import 'domain/usecase/user/current_user/post_bookmark_usecase.dart';
import 'domain/usecase/user/current_user/update_user_status_message_usecase.dart';
import 'domain/usecase/user/current_user/update_user_thumbnail_usecase.dart';
import 'presentation/router/router.dart';
import 'presentation/viewmodel/auth/auth_viewmodel.dart';
import 'presentation/viewmodel/dm/room/list/dm_room_list_viewmodel.dart';
import 'presentation/viewmodel/post/list/current_user_post_grid_list_viewmodel.dart';
import 'presentation/viewmodel/post/list/other_user_post_list_viewmodel.dart';
import 'presentation/viewmodel/user/current_user/get_user_info/current_user_info_viewmodel.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Lock the screen orientation to portrait mode.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final getIt = GetIt.instance;

  /// SecureStorage
  final secureStorageRepository = SecureStorageRepositoryImpl();
  final getAccessTokenUseCase = GetAccessTokenUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetAccessTokenUseCase>(getAccessTokenUseCase);
  final setAccessTokenUseCase = SetAccessTokenUseCase(secureStorageRepository: secureStorageRepository);

  /// Dio Singleton
  final Dio dio = DioSingleton.getInstance();
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.interceptors.add(TokenInterceptor(getAccessTokenUseCase: getAccessTokenUseCase));

  /// Log output only in debug mode
  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        compact: true,
      )
    );
  }

  /// Authentication
  // Repository
  final authRepository = AuthRepositoryImpl(dio);
  // UseCases
  final postSignInUseCase = PostSignInUseCase(authRepository: authRepository);
  // ViewModels
  final authViewModel = AuthViewModel(postSignInUseCase: postSignInUseCase, setAccessTokenUseCase: setAccessTokenUseCase);

  /// User
  // Repository
  final userRepository = UserRepositoryImpl(dio);
  // UseCases
  final getMyUserInfoUseCase = GetCurrentUserInfoUseCase(userRepository: userRepository);
  final getUserInfoByEmailUseCase = GetUserInfoByEmailUseCase(userRepository: userRepository);
  getIt.registerSingleton<GetUserInfoByEmailUseCase>(getUserInfoByEmailUseCase);
  final postBookmarkUseCase = PostBookmarkUseCase(userRepository: userRepository);
  getIt.registerSingleton<PostBookmarkUseCase>(postBookmarkUseCase);
  final updateUserThumbnailUseCase = UpdateUserThumbnailUseCase(userRepository: userRepository);
  getIt.registerSingleton<UpdateUserThumbnailUseCase>(updateUserThumbnailUseCase);
  final updateUserStatusMessageUseCase = UpdateUserStatusMessageUseCase(userRepository: userRepository);
  getIt.registerSingleton<UpdateUserStatusMessageUseCase>(updateUserStatusMessageUseCase);
  final getUserListByKeywordUseCase = GetUserListByKeywordUseCase(userRepository: userRepository);
  getIt.registerSingleton<GetUserListByKeywordUseCase>(getUserListByKeywordUseCase);
  // ViewModels
  final currentUserInfoViewModel = CurrentUserInfoViewModel(getCurrentUserInfoUseCase: getMyUserInfoUseCase);
  getIt.registerSingleton<CurrentUserInfoViewModel>(currentUserInfoViewModel);

  /// Feed(Post List)
  // Repository
  final postRepository = PostRepositoryImpl(dio);
  // UseCases
  final getPostListUseCase = GetPostListUseCase(postRepository: postRepository);
  getIt.registerSingleton<GetPostListUseCase>(getPostListUseCase);
  final getMyPostListUseCase = GetCurrentUserPostListUseCase(postRepository: postRepository);
  getIt.registerSingleton<GetCurrentUserPostListUseCase>(getMyPostListUseCase);
  final getPostListByUserEmailUseCase = GetPostListByUserEmailUseCase(postRepository: postRepository);
  getIt.registerSingleton<GetPostListByUserEmailUseCase>(getPostListByUserEmailUseCase);
  final updatePostDescriptionUseCase = UpdatePostDescriptionUseCase(postRepository: postRepository);
  getIt.registerSingleton<UpdatePostDescriptionUseCase>(updatePostDescriptionUseCase);
  final createPostUseCase = CreatePostUseCase(postRepository: postRepository);
  getIt.registerSingleton<CreatePostUseCase>(createPostUseCase);
  final postLikeUseCase = PostLikeUseCase(postRepository: postRepository);
  getIt.registerSingleton<PostLikeUseCase>(postLikeUseCase);
  final deletePostUseCase = DeletePostUseCase(postRepository: postRepository);
  getIt.registerSingleton<DeletePostUseCase>(deletePostUseCase);
  // ViewModels
  final myPostGridListViewModel = CurrentUserPostGridListViewModel(
      getPostListUseCase: getPostListUseCase,
      getMyPostListUseCase: getMyPostListUseCase,
  );
  // REFACTOR : Mid priority
  // REFACTOR : Replace the OtherUserPostGridListViewModel's scope to the UserDetailScreen

  // REFACTOR : The OtherUserPostGridListViewModel should located in the UserDetailScreen, because this ViewModel can be used only under UserDetailScreen's scope
  // REFACTOR : It's not a best practice, and it could cause side effects
  // REFACTOR : More than anything, I don't like this

  // REFACTOR : Actually, I tried just like that at the beginning, but there was a problem
  // REFACTOR : At the beginning, I created the OtherUserPostGridListViewModel inside of the UserDetailScreen
  // REFACTOR : And then created fragments UserDetailFragment, and FeedFragment with a PageView inside of the UserDetailScreen
  // REFACTOR : I injected a ItemScrollController to UserDetailFragment, FeedFragment from UserDetailScreen
  // REFACTOR : I thought the UserDetailFragment can control the FeedFragment's ItemScrollController from the injected ItemScrollController object
  // REFACTOR : But ItemScrollController couldn't be injected with Provider, and I don't know why
  // REFACTOR : I can't help but I had to replace the OtherUserPostGridListViewModel to main() from UserDetailScreen
  // REFACTOR : Maybe, I can refactor it after the DirectMessage feature is implemented later
  final otherUserPostGridListViewModel = OtherUserPostGridListViewModel(
      getPostListUseCase: getPostListUseCase,
      getPostListByUserEmailUseCase: getPostListByUserEmailUseCase,
  );

  /// Comment/Reply
  // Repository
  final commentRepository = CommentRepositoryImpl(dio);
  // UseCases
  final getCommentUseCase = GetCommentListUseCase(commentRepository: commentRepository);
  getIt.registerSingleton<GetCommentListUseCase>(getCommentUseCase);
  final createCommentUseCase = CreateCommentUseCase(commentRepository: commentRepository);
  getIt.registerSingleton<CreateCommentUseCase>(createCommentUseCase);
  final deleteCommentUseCase = DeleteCommentUseCase(commentRepository: commentRepository);
  getIt.registerSingleton<DeleteCommentUseCase>(deleteCommentUseCase);
  final updateCommentUseCase = UpdateCommentUseCase(commentRepository: commentRepository);
  getIt.registerSingleton<UpdateCommentUseCase>(updateCommentUseCase);

  /// DM
  final dmRepository = DmRepositoryImpl(dio);
  // UseCases
  final createDmRoomUseCase = CreateDmRoomUseCase(dmRepository: dmRepository);
  getIt.registerSingleton<CreateDmRoomUseCase>(createDmRoomUseCase);
  final getDmRoomListUseCase = GetDmRoomListUseCase(dmRepository: dmRepository);
  getIt.registerSingleton<GetDmRoomListUseCase>(getDmRoomListUseCase);
  // ViewModels
  final dmRoomListViewModel = DmRoomListViewModel(getDmRoomListUseCase: getDmRoomListUseCase);

  /// Follow
  final followRepository = FollowRepositoryImpl(dio);
  // UseCases
  final startFollowUseCase = StartFollowUseCase(followRepository: followRepository);
  getIt.registerSingleton<StartFollowUseCase>(startFollowUseCase);
  final unfollowUseCase = UnfollowUseCase(followRepository: followRepository);
  getIt.registerSingleton<UnfollowUseCase>(unfollowUseCase);
  final getFollowerListUseCase = GetFollowerListUseCase(followRepository: followRepository);
  getIt.registerSingleton<GetFollowerListUseCase>(getFollowerListUseCase);
  final getFollowingListUseCase = GetFollowingListUseCase(followRepository: followRepository);
  getIt.registerSingleton<GetFollowingListUseCase>(getFollowingListUseCase);

  await Firebase.initializeApp();

  final String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('FirebaseMessaging: fcmToken => $fcmToken');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => authViewModel,
        ),
        /// Current user information
        Provider<CurrentUserInfoViewModel>(
          create: (context) => currentUserInfoViewModel,
        ),
        /// Current user's grid feed
        Provider<CurrentUserPostGridListViewModel>(
          create: (context) => myPostGridListViewModel,
        ),
        /// Other user's grid feed
        Provider<OtherUserPostGridListViewModel>(
          create: (context) => otherUserPostGridListViewModel,
        ),
        /// DM room list
        Provider<DmRoomListViewModel>(
          create: (context) => dmRoomListViewModel,
        ),
      ],
      child: const App(),
    ),
  );

}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }

}
