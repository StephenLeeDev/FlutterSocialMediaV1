import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';

import 'data/networking/dio_singleton.dart';
import 'data/networking/interceptor/token_interceptor.dart';
import 'data/repository/auth/auth_repository_impl.dart';
import 'data/repository/comment/comment_repository_impl.dart';
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
import 'domain/usecase/post/create/create_post_usecase.dart';
import 'domain/usecase/post/delete/delete_post_usecase.dart';
import 'domain/usecase/post/list/get_post_list_usecase.dart';
import 'domain/usecase/post/like/post_like_usecase.dart';
import 'domain/usecase/user/get_my_user_info_usecase.dart';
import 'domain/usecase/user/post_bookmark_usecase.dart';
import 'presentation/router/router.dart';
import 'presentation/viewmodel/auth/auth_viewmodel.dart';
import 'presentation/viewmodel/user/my_info/my_user_info_viewmodel.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: '.env.${kReleaseMode ? 'release' : 'debug'}');
  // await dotenv.load(fileName: '.env.debug');

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
  dio.options.connectTimeout = const Duration(seconds: 10);
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
  final authRepository = AuthRepositoryImpl(dio);
  final postSignInUseCase = PostSignInUseCase(authRepository: authRepository);
  final authViewModel = AuthViewModel(postSignInUseCase: postSignInUseCase, setAccessTokenUseCase: setAccessTokenUseCase);

  /// User
  final userRepository = UserRepositoryImpl(dio);
  final getMyUserInfoUseCase = GetMyUserInfoUseCase(userRepository: userRepository);
  final postBookmarkUseCase = PostBookmarkUseCase(userRepository: userRepository);
  getIt.registerSingleton<PostBookmarkUseCase>(postBookmarkUseCase);
  final myUserInfoViewModel = MyUserInfoViewModel(getMyUserInfoUseCase: getMyUserInfoUseCase);
  getIt.registerSingleton<MyUserInfoViewModel>(myUserInfoViewModel);

  /// Feed(Post List)
  final postRepository = PostRepositoryImpl(dio);
  final getPostListUseCase = GetPostListUseCase(postRepository: postRepository);
  getIt.registerSingleton<GetPostListUseCase>(getPostListUseCase);
  final createPostUseCase = CreatePostUseCase(postRepository: postRepository);
  getIt.registerSingleton<CreatePostUseCase>(createPostUseCase);
  final postLikeUseCase = PostLikeUseCase(postRepository: postRepository);
  getIt.registerSingleton<PostLikeUseCase>(postLikeUseCase);
  final deletePostUseCase = DeletePostUseCase(postRepository: postRepository);
  getIt.registerSingleton<DeletePostUseCase>(deletePostUseCase);

  /// Comment/Reply
  final commentRepository = CommentRepositoryImpl(dio);
  final getCommentUseCase = GetCommentListUseCase(commentRepository: commentRepository);
  getIt.registerSingleton<GetCommentListUseCase>(getCommentUseCase);
  final createCommentUseCase = CreateCommentUseCase(commentRepository: commentRepository);
  getIt.registerSingleton<CreateCommentUseCase>(createCommentUseCase);
  final deleteCommentUseCase = DeleteCommentUseCase(commentRepository: commentRepository);
  getIt.registerSingleton<DeleteCommentUseCase>(deleteCommentUseCase);
  final updateCommentUseCase = UpdateCommentUseCase(commentRepository: commentRepository);
  getIt.registerSingleton<UpdateCommentUseCase>(updateCommentUseCase);

  await Firebase.initializeApp();

  final String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('FirebaseMessaging: fcmToken => $fcmToken');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => authViewModel,
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
