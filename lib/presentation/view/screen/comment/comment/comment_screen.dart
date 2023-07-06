import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/comment/list/comment_list_state.dart' as CommentListState;
import '../../../../../data/model/comment/item/comment_model.dart';
import '../../../../../data/model/comment/create/create_comment_state.dart' as CreateCommentState;
import '../../../../../domain/usecase/comment/create/create_comment_usecase.dart';
import '../../../../../domain/usecase/comment/list/get_comment_list_usecase.dart';
import '../../../../util/keyboard/keyboard_util.dart';
import '../../../../viewmodel/comment/list/comment_list_viewmodel.dart';
import '../../../../viewmodel/comment/create/create_comment_viewmodel.dart';
import '../../../../viewmodel/user/my_info/my_user_info_viewmodel.dart';
import '../../../widget/comment/comment_widget.dart';
import '../../../widget/common/empty/empty_widget.dart';
import '../../../widget/common/error/error_widget.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  static const String routeName = "postComment";
  static const String routeURL = "/comment/:postId";

  final String postId;
  int get getPostId {
    try {
      return int.parse(postId);
    } catch (e) {
      return -1;
    }
  }

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  late CommentListViewModel commentListViewModel;
  late CreateCommentViewModel createCommentViewModel;

  final myEmail = GetIt.instance<MyUserInfoViewModel>().myEmail;

  @override
  void initState() {
    super.initState();

    initViews();
    initListViewModel();
    initCreateViewModel();
    fetchCommentList();
  }

  /// List
  void initListViewModel() {
    commentListViewModel = CommentListViewModel(getCommentListUseCase: GetIt.instance<GetCommentListUseCase>());
    commentListViewModel.setPostId(value: widget.getPostId);
    commentListViewModel.setMyEmail(value: myEmail);
  }

  /// Create
  void initCreateViewModel() {
    createCommentViewModel = CreateCommentViewModel(createCommentUseCase: GetIt.instance<CreateCommentUseCase>());
    createCommentViewModel.setPostId(value: widget.getPostId);
  }

  /// Views
  void initViews() {
    _scrollController.addListener(_scrollListener);
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
        body: SafeArea(
          child: GestureDetector(
            onTap: () => KeyboardUtil().dismissKeyboard(context),
            child: Column(
              children: [
                /// Loading, Success, Fail UI branching
                Expanded(
                  child: ValueListenableBuilder<CommentListState.CommentListState>(
                    valueListenable: commentListViewModel.commentListStateNotifier,
                    builder: (context, state, _) {
                      if (state is CommentListState.Loading &&
                          commentListViewModel.currentList.isEmpty) {
                        return buildLoadingStateUI();
                      } else if (state is CommentListState.Fail) {
                        return buildFailStateUI();
                      } else {
                        return buildSuccessStateUI();
                      }
                    },
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
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(),
                          ),
                          minLines: 1,
                          maxLines: 4,
                          maxLength: 200,
                          onChanged: (value) {
                            createCommentViewModel.setContent(value: value);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ValueListenableBuilder<bool>(
                          valueListenable: createCommentViewModel.isValidNotifier,
                          builder: (context, isValid, _) {
                            return InkWell(
                              enableFeedback: false,
                              child: IconButton(
                                onPressed: () async {
                                  if (isValid) {
                                    final state = await createCommentViewModel.createComment();
                                    if (state is CreateCommentState.Success) {
                                      final CommentModel newComment = state.value;
                                      newComment.isMine = true;
                                      onNewComment(newComment: newComment);
                                      _textEditingController.text = "";
                                    }
                                  }
                                },
                                icon: Icon(Icons.send,
                                    color: isValid ? Colors.black : Colors.grey.shade400,
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReadyStateUI() {
    return Container();
  }

  Widget buildLoadingStateUI() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return const Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildFailStateUI() {
    return CustomErrorWidget(listener: () {
      fetchCommentList();
    });
  }

  Widget buildSuccessStateUI() {
    return ValueListenableBuilder<List<CommentModel>>(
      valueListenable: commentListViewModel.currentListNotifier,
      builder: (context, list, _) {
        return Stack(
          children: [
            /// List UI
            RefreshIndicator(
              onRefresh: () => commentListViewModel.refresh(),
              child: ValueListenableBuilder<List<CommentModel>>(
                valueListenable: commentListViewModel.currentListNotifier,
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
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 20),
                  );
                },
              ),
            ),
            /// Empty message UI
            if (list.isEmpty) const EmptyWidget(message: "No comments yet"),
          ],
        );
      },
    );
  }

  void fetchCommentList() {
    commentListViewModel.getCommentList();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      fetchCommentList();
    }
  }

  /// When a new comment is created, add it to the list and scroll to it
  void onNewComment({required CommentModel newComment}) {
    KeyboardUtil().dismissKeyboard(context);
    createCommentViewModel.setContent(value: "");
    commentListViewModel.prependNewCommentToList(additionalList: [newComment]);
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
