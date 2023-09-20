import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../values/text/text.dart';
import '../../../../../data/model/comment/item/comment_item_state.dart' as CommentItemState;
import '../../../../../data/model/comment/list/comment_list_state.dart' as CommentListState;
import '../../../../../data/model/comment/item/comment_model.dart';
import '../../../../../data/model/common/enum_create_update.dart';
import '../../../../../domain/usecase/comment/create/create_comment_usecase.dart';
import '../../../../../domain/usecase/comment/list/get_comment_list_usecase.dart';
import '../../../../../domain/usecase/comment/update/update_comment_usecase.dart';
import '../../../../util/custom_toast/custom_toast_util.dart';
import '../../../../util/dialog/dialog_util.dart';
import '../../../../util/keyboard/keyboard_util.dart';
import '../../../../viewmodel/comment/list/comment_list_viewmodel.dart';
import '../../../../viewmodel/comment/create/create_comment_viewmodel.dart';
import '../../../../viewmodel/comment/update/update_comment_viewmodel.dart';
import '../../../../viewmodel/user/current_user/get_user_info/current_user_info_viewmodel.dart';
import '../../../widget/comment/comment_widget.dart';
import '../../../widget/common/empty/empty_widget.dart';
import '../../../widget/common/error/error_widget.dart';

class ReplyScreen extends StatefulWidget {
  const ReplyScreen({Key? key, required this.postId, required this.commentString}) : super(key: key);

  static const String routeName = "postCommentReply";
  static const String routeURL = "/comment/reply";

  final String postId;
  int get getPostId {
    try {
      return int.parse(postId);
    } catch (e) {
      return -1;
    }
  }
  final String commentString;

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  late CommentListViewModel commentListViewModel;
  late CreateCommentViewModel createCommentViewModel;
  late UpdateCommentViewModel updateCommentViewModel;

  final myEmail = GetIt.instance<CurrentUserInfoViewModel>().myEmail;
  late final CommentModel? _commentModel;

  /// It's used for branching the creation/update logic
  CreateUpdateMode _mode = CreateUpdateMode.create;
  bool get _isCreateMode => _mode == CreateUpdateMode.create; // true == create, false == update

  @override
  void initState() {
    super.initState();

    initViewModels();
    initData();
    initViews();
    fetchCommentList();
  }

  /// Basic data
  void initData() {
    if (widget.commentString.isNotEmpty) {
      _commentModel = CommentModel.fromJson(jsonDecode(widget.commentString));
      commentListViewModel.setParentComment(commentModel: _commentModel);
      commentListViewModel.prependNewListToCurrentList(additionalList: [_commentModel!]);
      createCommentViewModel.setParentCommentId(value: _commentModel?.id);
      createCommentViewModel.setParentCommentAuthor(value: _commentModel?.user?.email);
    }
  }

  /// ViewModels
  void initViewModels() {
    initListViewModel();
    initCreateViewModel();
    initUpdateViewModel();
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

  /// Update
  void initUpdateViewModel() {
    updateCommentViewModel = UpdateCommentViewModel(updateCommentUseCase: GetIt.instance<UpdateCommentUseCase>());
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
            "Replies",
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
                      /// Loading UI
                      if (state is CommentListState.Loading && commentListViewModel.currentList.length == 1) {
                        return buildLoadingStateUI();
                      }
                      /// Fail UI
                      else if (state is CommentListState.Fail) {
                        return buildFailStateUI();
                      }
                      /// Success UI (default)
                      else {
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
                  child: GestureDetector(
                    onTap: () => showModalBottomKeyboard(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            decoration: const InputDecoration(
                              hintText: addAReply,
                              border: OutlineInputBorder(),
                            ),
                            minLines: 1,
                            maxLines: 4,
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
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
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : 30),
                    child: CommentWidget(
                      isComment: false,
                      isWhiteBackground: index == 0 ? false : true,
                      commentModel: list[index],
                      updateCallback: () {
                        final comment = list[index];
                        updateCommentViewModel.setCommentId(value: comment.commentId);
                        _mode = CreateUpdateMode.update;
                        _textEditingController.text = comment.getContent;
                        showModalBottomKeyboard(commentItemToUpdate: comment);
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
              ),
            ),
            /// Empty message UI
            if (list.length == 1) const EmptyWidget(message: noRepliesYet),
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
    commentListViewModel.prependNewListToCurrentList(index: 1, additionalList: [newComment]);
    _scrollController.animateTo(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  /// When a comment is updated, replace it from the list
  void onCommentUpdated({required CommentModel updatedComment}) {
    KeyboardUtil().dismissKeyboard(context);
    updateCommentViewModel.setUpdatedContent(value: "");
    commentListViewModel.replaceUpdatedItemFromList(updatedComment: updatedComment);
    _mode = CreateUpdateMode.create;
    _textEditingController.text = "";
  }

  /// Shows a bottom sheet modal for keyboard input.
  void showModalBottomKeyboard({CommentModel? commentItemToUpdate}) {
    final FocusNode focusNode = FocusNode();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        Future.delayed(Duration.zero, () {
          FocusScope.of(buildContext).requestFocus(focusNode);
        });
        return
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(buildContext).viewInsets.bottom),
            child: Container(
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
                      focusNode: focusNode,
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: addAReply,
                        border: OutlineInputBorder(),
                      ),
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 200,
                      onChanged: (value) {
                        /// On creating a new comment
                        if (_isCreateMode) {
                          createCommentViewModel.setContent(value: value);
                        }
                        /// On updating a comment
                        else {
                          updateCommentViewModel.setUpdatedContent(value: value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  /// On creating a new comment
                  if (_isCreateMode)
                    ValueListenableBuilder<bool>(
                      valueListenable: createCommentViewModel.isValidNotifier,
                      builder: (buildContext, isValid, _) {
                        return IconButton(
                          onPressed: () async {
                            if (isValid) {
                              final state = await createCommentViewModel.createComment();
                              /// A new comment created successfully
                              if (state is CommentItemState.Success) {
                                final CommentModel newComment = state.item;
                                newComment.isMine = true;
                                onNewComment(newComment: newComment);
                                _textEditingController.text = "";

                                if (buildContext.mounted) Navigator.pop(buildContext);
                                if (context.mounted) showCustomToastWithTimer(context: context, message: commentCreatedMessage);
                              }
                            }
                          },
                          icon: Icon(Icons.send,
                            color: isValid ? Colors.black : Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  /// On updating a comment
                  if (!_isCreateMode)
                    ValueListenableBuilder<bool>(
                      valueListenable: updateCommentViewModel.isValidNotifier,
                      builder: (buildContext, isValid, _) {
                        return IconButton(
                          onPressed: () async {
                            if (isValid) {
                              final state = await updateCommentViewModel.updateComment();
                              if (state is CommentItemState.Success) {
                                _mode = CreateUpdateMode.create;
                                final CommentModel updatedComment = state.item;
                                updatedComment.isMine = true;
                                onCommentUpdated(updatedComment: updatedComment);
                                _textEditingController.text = "";

                                if (buildContext.mounted) Navigator.pop(buildContext);
                                if (context.mounted) showCustomToastWithTimer(context: context, message: commentUpdatedMessage);
                              }
                            }
                          },
                          icon: Icon(Icons.send,
                            color: isValid ? Colors.black : Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
      },
    ).then((value) {
      /// It means, it was updating a comment
      if (commentItemToUpdate != null) {
        /// Updating comment task has completed successfully
        /// Proceed initializing
        if (updateCommentViewModel.updateCommentState is CommentItemState.Success) {
          updateCommentViewModel.setCommentItemState(updateCommentState: CommentItemState.Ready());
        }
        /// Updating comment task has not completed
        /// Recommend continue updating
        else if (updateCommentViewModel.updateCommentState is CommentItemState.Ready) {
          showCancelUpdateDialog(commentItemToUpdate: commentItemToUpdate);
        }
      }
    });
  }

  void showCancelUpdateDialog({required CommentModel commentItemToUpdate}) {
    showTwoButtonDialog(
      context: context,
      title: discardEdits,
      /// Cancel updating and discard
      firstButtonText: discard,
      firstButtonListener: () {
        _mode = CreateUpdateMode.create;
        updateCommentViewModel.initUpdateStatus();
        _textEditingController.text = "";
      },
      /// Keep writing
      secondButtonText: keepWriting,
      secondButtonListener: () {
        showModalBottomKeyboard(commentItemToUpdate: commentItemToUpdate);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}