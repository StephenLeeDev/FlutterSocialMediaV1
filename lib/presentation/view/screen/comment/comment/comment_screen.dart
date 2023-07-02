import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/comment/comment_model.dart';
import '../../../../../data/model/comment/create/create_comment_state.dart';
import '../../../../util/keyboard/keyboard_util.dart';
import '../../../../viewmodel/comment/comment_list_viewmodel.dart';
import '../../../../viewmodel/comment/create_comment_viewmodel.dart';
import '../../../widget/comment/comment_widget.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  final _scrollController = ScrollController();
  late CommentListViewModel commentListViewModel;
  late CreateCommentViewModel createCommentViewModel;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    commentListViewModel = context.read<CommentListViewModel>();
    createCommentViewModel = context.read<CreateCommentViewModel>();

    commentListViewModel.getCommentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => commentListViewModel.refresh(),
                child: Selector<CommentListViewModel, List<CommentModel>>(
                    selector: (_, viewModel) => viewModel.currentList,
                    builder: (context, list, _) {
                      return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: CommentWidget(
                              commentModel: list[index],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
                      );
                    },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                      ),
                      minLines: 1,
                      maxLines: 4,
                      onChanged: (value) {
                        createCommentViewModel.setContent(value: value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Selector<CreateCommentViewModel, bool>(
                    selector: (_, viewModel) => viewModel.isValid,
                    builder: (context, isValid, _) {
                      return IconButton(
                        onPressed: () async {
                          if (isValid) {
                            final state = await createCommentViewModel.createComment();
                            if (state is Success) {
                              final CommentModel newComment = state.value;
                              onNewComment(newComment: newComment);
                            }
                          }
                        },
                        icon: Icon(Icons.send, color: isValid ? Colors.black : Colors.grey),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      commentListViewModel.getCommentList();
    }
  }

  /// When a new comment is created, add it to the list and scroll to it
  void onNewComment({required CommentModel newComment}) {
    KeyboardUtil().dismissKeyboard(context);
    createCommentViewModel.setContent(value: "");
    commentListViewModel.prependNewCommentToList(additionalList: [newComment]);
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
