import 'package:flutter/material.dart';
import 'package:flutter_social_media_v1/presentation/view/screen/comment/comment_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../domain/usecase/comment/get_comment_list_usecase.dart';
import '../../../viewmodel/comment/comment_list_viewmodel.dart';

class CommentScreenWrapper extends StatefulWidget {
  const CommentScreenWrapper({Key? key, required this.postId}) : super(key: key);

  static const String routeName = "postComment";
  static const String routeURL = "/comment/:postId";

  final String postId;
  int get getCommentId {
    try {
      return int.parse(postId);
    } catch (e) {
      return -1;
    }
  }

  @override
  State<CommentScreenWrapper> createState() => _CommentScreenWrapperState();
}

class _CommentScreenWrapperState extends State<CommentScreenWrapper> {

  late final CommentListViewModel commentListViewModel;

  @override
  void initState() {
    super.initState();
    commentListViewModel = CommentListViewModel(getCommentListUseCase: GetIt.instance<GetCommentListUseCase>());
    commentListViewModel.setPostId(value: widget.getCommentId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommentListViewModel>(
          create: (context) => commentListViewModel,
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          title: const Text(
            "Comments",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        body: const CommentScreen(),
      ),
    );
  }
}
