import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_social_media_v1/domain/usecase/auth/post_sign_in_usecase.dart';
import 'package:flutter_social_media_v1/presentation/ui/screen/auth/auth_screen.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import 'data/repository/auth/auth_repository_impl.dart';

void main() async {

  // await dotenv.load(fileName: '.env.${kReleaseMode ? 'release' : 'debug'}');
  // await dotenv.load(fileName: '.env.debug');

  /// Authentication
  final authRepository = AuthRepositoryImpl();
  final postSignInUseCase = PostSignInUseCase(authRepository: authRepository);
  final authViewModel = AuthViewModel(postSignInUseCase: postSignInUseCase);

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthScreen(),
    );
  }
}
