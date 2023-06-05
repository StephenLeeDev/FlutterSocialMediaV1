import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_social_media_v1/data/repository/post/post_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/get_access_token_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/post_sign_in_usecase.dart';
import 'package:flutter_social_media_v1/domain/usecase/post/get_post_list_usecase.dart';
import 'package:flutter_social_media_v1/presentation/router/router.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/post_list_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'data/repository/auth/auth_repository_impl.dart';
import 'domain/usecase/auth/set_access_token_usecase.dart';

void main() async {

  // await dotenv.load(fileName: '.env.${kReleaseMode ? 'release' : 'debug'}');
  // await dotenv.load(fileName: '.env.debug');

  /// Authentication
  final authRepository = AuthRepositoryImpl();
  final postSignInUseCase = PostSignInUseCase(authRepository: authRepository);
  final getAccessTokenUseCase = GetAccessTokenUseCase(authRepository: authRepository);
  final setAccessTokenUseCase = SetAccessTokenUseCase(authRepository: authRepository);
  final authViewModel = AuthViewModel(
      postSignInUseCase: postSignInUseCase,
      setAccessTokenUseCase: setAccessTokenUseCase
  );

  /// Feed(Post)
  final postRepository = PostRepositoryImpl();
  final getPostListUseCase = GetPostListUseCase(postRepository: postRepository);
  final postListViewModel = PostListViewModel(getPostListUseCase: getPostListUseCase);

  final getIt = GetIt.instance;
  getIt.registerSingleton<GetAccessTokenUseCase>(getAccessTokenUseCase);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => authViewModel,
        ),
        ChangeNotifierProvider<PostListViewModel>(
          create: (context) => postListViewModel,
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
        routerConfig: router
    );
  }

}
