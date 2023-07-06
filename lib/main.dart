import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_social_media_v1/data/repository/comment/comment_repository_impl.dart';
import 'package:flutter_social_media_v1/data/repository/post/post_repository_impl.dart';
import 'package:flutter_social_media_v1/data/repository/secure_storage/secure_storage_repository_impl.dart';
import 'package:flutter_social_media_v1/data/repository/user/user_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/get_access_token_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/post_sign_in_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/comment/create/create_comment_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/comment/list/get_comment_list_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/post/get_post_list_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/post/post_like_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/user/get_my_user_info_usecase.dart';
import 'package:flutter_social_media_v1/presentation/router/router.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/list/post_list_viewmodel.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/user/my_info/my_user_info_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';

import 'data/networking/dio_singleton.dart';
import 'data/networking/interceptor/token_interceptor.dart';
import 'data/repository/auth/auth_repository_impl.dart';
import 'domain/usecase/auth/set_access_token_usecase.dart';
import 'domain/usecase/comment/delete/delete_comment_usecase.dart';
import 'domain/usecase/user/post_bookmark_usecase.dart';
import 'presentation/viewmodel/post/like/post_like_viewmodel.dart';
import 'presentation/viewmodel/user/bookmark/bookmark_viewmodel.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: '.env.${kReleaseMode ? 'release' : 'debug'}');
  // await dotenv.load(fileName: '.env.debug');

  final getIt = GetIt.instance;

  /// SecureStorage
  final secureStorageRepository = SecureStorageRepositoryImpl();
  final getAccessTokenUseCase = GetAccessTokenUseCase(secureStorageRepository: secureStorageRepository);
  final setAccessTokenUseCase = SetAccessTokenUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetAccessTokenUseCase>(getAccessTokenUseCase);

  /// Dio Singleton
  final Dio dio = DioSingleton.getInstance();
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
  final authViewModel = AuthViewModel(
      postSignInUseCase: postSignInUseCase,
      setAccessTokenUseCase: setAccessTokenUseCase
  );

  /// User
  final userRepository = UserRepositoryImpl(dio);
  final getMyUserInfoUseCase = GetMyUserInfoUseCase(userRepository: userRepository);
  final postBookmarkUseCase = PostBookmarkUseCase(userRepository: userRepository);
  final myUserInfoViewModel = MyUserInfoViewModel(getMyUserInfoUseCase: getMyUserInfoUseCase);
  final bookmarkViewModel = BookmarkViewModel(postBookmarkUseCase: postBookmarkUseCase);
  getIt.registerSingleton<MyUserInfoViewModel>(myUserInfoViewModel);

  /// Feed(Post List)
  final postRepository = PostRepositoryImpl(dio);
  final getPostListUseCase = GetPostListUseCase(postRepository: postRepository);
  final postLikeUseCase = PostLikeUseCase(postRepository: postRepository);
  final postListViewModel = PostListViewModel(getPostListUseCase: getPostListUseCase);
  final postLikeViewModel = PostLikeViewModel(postLikeUseCase: postLikeUseCase);
  getIt.registerSingleton<PostLikeViewModel>(postLikeViewModel);

  /// Comment/Reply
  final commentRepository = CommentRepositoryImpl(dio);
  final getCommentUseCase = GetCommentListUseCase(commentRepository: commentRepository);
  final createCommentUseCase = CreateCommentUseCase(commentRepository: commentRepository);
  final deleteCommentUseCase = DeleteCommentUseCase(commentRepository: commentRepository);
  getIt.registerSingleton<GetCommentListUseCase>(getCommentUseCase);
  getIt.registerSingleton<CreateCommentUseCase>(createCommentUseCase);
  getIt.registerSingleton<DeleteCommentUseCase>(deleteCommentUseCase);

  await Firebase.initializeApp();
  FirebaseMessaging fbMsg = FirebaseMessaging.instance;

  final String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('FirebaseMessaging: fcmToken => $fcmToken');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => authViewModel,
        ),
        ChangeNotifierProvider<BookmarkViewModel>(
          create: (context) => bookmarkViewModel,
        ),
        ChangeNotifierProvider<PostListViewModel>(
          create: (context) => postListViewModel,
        ),
      ],
      child: const App(),
    ),
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel? androidNotificationChannel;
  if (Platform.isIOS) {
    await reqIOSPermission(fbMsg);
  } else if (Platform.isAndroid) {
    androidNotificationChannel = const AndroidNotificationChannel(
      'important_channel',
      'Important_Notifications',
      description: '중요도가 높은 알림을 위한 채널.',
      // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }
  //Background Handling 백그라운드 메세지 핸들링
  FirebaseMessaging.onBackgroundMessage(fbMsgBackgroundHandler);
  //Foreground Handling 포어그라운드 메세지 핸들링
  FirebaseMessaging.onMessage.listen((message) {
    fbMsgForegroundHandler(message, flutterLocalNotificationsPlugin, androidNotificationChannel);
  });
  //Message Click Event Implement
  await setupInteractedMessage(fbMsg);

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

Future reqIOSPermission(FirebaseMessaging fbMsg) async {
  NotificationSettings settings = await fbMsg.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

Future<void> fbMsgBackgroundHandler(RemoteMessage message) async {
  print("[FCM - Background] MESSAGE : ${message.messageId}");
}

Future<void> fbMsgForegroundHandler(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel? channel) async {
  print('[FCM - Foreground] MESSAGE : ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
    print('message title : ${message.notification?.title}');
    print('message body : ${message.notification?.body}');
    flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(
              badgeNumber: 1,
              subtitle: 'the subtitle',
              sound: 'slow_spring_board.aiff',
            )));
  }
}

Future<void> setupInteractedMessage(FirebaseMessaging fbMsg) async {
  RemoteMessage? initialMessage = await fbMsg.getInitialMessage();
  // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
  if (initialMessage != null) clickMessageEvent(initialMessage);
  // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
  FirebaseMessaging.onMessageOpenedApp.listen(clickMessageEvent);
}

void clickMessageEvent(RemoteMessage message) {
  print('message : ${message.notification!.title}');
  // Get.toNamed('/');
}
