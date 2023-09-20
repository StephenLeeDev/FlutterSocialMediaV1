import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../values/text/text.dart';
import '../../../../data/model/comment/item/comment_model.dart';
import '../../../../data/model/common/common_state.dart';
import '../../../../domain/usecase/comment/delete/delete_comment_usecase.dart';
import '../../../util/bottom_sheet/bottom_sheet_util.dart';
import '../../../util/custom_toast/custom_toast_util.dart';
import '../../../util/date/date_util.dart';
import '../../../util/dialog/dialog_util.dart';
import '../../../viewmodel/comment/delete/delete_comment_viewmodel.dart';
import '../../../viewmodel/comment/list/comment_list_viewmodel.dart';
import '../../screen/comment/reply/reply_screen.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({Key? key, required this.commentModel, required this.updateCallback, this.isComment = true, this.isWhiteBackground = true}) : super(key: key);

  final CommentModel commentModel;
  final VoidCallback updateCallback;
  final bool isComment; /// true == comment, false == reply
  final bool isWhiteBackground; /// true == white, false == grey

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  late final CommentListViewModel _commentListViewModel;
  late final DeleteCommentViewModel _deleteCommentViewModel;

  @override
  void initState() {
    super.initState();

    initViewModels();
  }

  initViewModels() {
    initListViewModel();
    initDeleteViewModel();
  }

  /// List
  initListViewModel() {
    _commentListViewModel = context.read<CommentListViewModel>();
  }

  /// Delete
  initDeleteViewModel() {
    _deleteCommentViewModel = DeleteCommentViewModel(deleteCommentUseCase: GetIt.instance<DeleteCommentUseCase>());
  }

  @override
  Widget build(BuildContext context) {
    const double constantPadding = 12;
    String dateString = widget.commentModel.createdAt != null ? widget.commentModel.createdAt.toString() : "";

    return MultiProvider(
      providers: [
        Provider<DeleteCommentViewModel>(
          create: (context) => _deleteCommentViewModel,
        ),
      ],
      child: Container(
        color: widget.isWhiteBackground ? Colors.white : Colors.grey.shade100,
        padding: const EdgeInsets.all(constantPadding),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: constantPadding),
                width: 30,
                height: 30,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  widget.commentModel.user?.thumbnail ?? "",
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.commentModel.getUserName,
                          style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45),
                        ),
                        Text(
                          " · ${DateUtil().getTimeAgo(dateString)}",
                          style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45),
                        ),
                        if (widget.commentModel.isUpdated())
                        const Text(
                          " (edited)",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                    Text(
                      widget.commentModel.getContent,
                      style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(height: constantPadding),
                    /// 'Replies' count shows when only on comment item, not reply
                    if (widget.isComment)
                    GestureDetector(
                      onTap: () async {
                        final postId = widget.commentModel.postId ?? -1;
                        if (postId > 0) {
                          int? deletedCommentId = await context.pushNamed(
                            ReplyScreen.routeName,
                            queryParameters: {
                              'postId': "$postId",
                              CommentModel().getSimpleName(): jsonEncode(widget.commentModel),
                            },
                          );
                          /// If deleted comment exists, remove it from the list
                          if (deletedCommentId != null) {
                            _commentListViewModel.removeDeletedItemFromList(commentId: deletedCommentId);
                          }
                        }
                      },
                      child: Text(
                        "${widget.commentModel.getChildrenCount} ${(widget.commentModel.getChildrenCount == 1) ? "Reply" : "Replies"}",
                        style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.commentModel.isMine)
                IconButton(
                  color: Colors.grey,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.grey,
                  ),

                  onPressed: () => {
                    /// Show Edit/Delete bottom sheet
                    showEditDeleteBottomModal()
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showEditDeleteBottomModal() {
    showTwoButtonBottomSheetCupertino(
      context: context,
      title: comment,

      /// Delete button
      firstButtonIcon: Icons.delete_forever,
      firstButtonText: delete,
      firstButtonListener: () {
        deleteCommentConfirmModal();
      },
      /// Edit button
      secondButtonIcon: Icons.edit,
      secondButtonText: edit,
      secondButtonListener: () {
        widget.updateCallback();
      },
    );
  }

  void deleteCommentConfirmModal() {
    showTwoButtonDialog(
        context: context,
        title: deleteComment,
        message: deleteCommentConfirm,
        /// Delete button
        firstButtonText: delete,
        firstButtonListener: () {
          deleteCommentFeature();
        },
        /// Cancel button
        secondButtonText: cancel,
    );
  }

  void deleteCommentFeature() async {
    final commentId = widget.commentModel.commentId;
    /// Delete the comment
    final state = await _deleteCommentViewModel.deleteComment(commentId: commentId);
    if (state is Success) {
      /// Close the current screen, when it's replies screen
      if (!widget.isWhiteBackground && context.mounted) Navigator.pop(context, commentId);

      if (context.mounted) showCustomToastWithTimer(context: context, message: commentDeletedMessage);
      /// Remove the deleted comment from the list
      _commentListViewModel.removeDeletedItemFromList(commentId: commentId);
    }
  }
}
