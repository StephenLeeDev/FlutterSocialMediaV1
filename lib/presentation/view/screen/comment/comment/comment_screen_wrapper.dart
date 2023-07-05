import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/usecase/comment/create_comment_usecase.dart';
import '../../../../../domain/usecase/comment/get_comment_list_usecase.dart';
import '../../../../viewmodel/comment/list/comment_list_viewmodel.dart';
import '../../../../viewmodel/comment/create/create_comment_viewmodel.dart';
import 'comment_screen.dart';

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
  late final CreateCommentViewModel createCommentViewModel;

  @override
  void initState() {
    super.initState();
    /// Read
    commentListViewModel = CommentListViewModel(getCommentListUseCase: GetIt.instance<GetCommentListUseCase>());
    commentListViewModel.setPostId(value: widget.getCommentId);

    /// Create
    createCommentViewModel = CreateCommentViewModel(createCommentUseCase: GetIt.instance<CreateCommentUseCase>());
    createCommentViewModel.setPostId(value: widget.getCommentId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CommentListViewModel>(
          create: (context) => commentListViewModel,
        ),
        Provider<CreateCommentViewModel>(
          create: (context) => createCommentViewModel,
        ),
      ],
      child: const CommentScreen(),
    );
  }
}
