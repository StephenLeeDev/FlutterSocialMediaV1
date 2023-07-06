import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../data/constant/text.dart';
import '../../../../data/model/comment/item/comment_model.dart';
import '../../../../data/model/common/common_state.dart';
import '../../../../domain/usecase/comment/delete/delete_comment_usecase.dart';
import '../../../util/bottom_sheet/bottom_sheet_util.dart';
import '../../../util/custom_toast/custom_toast_util.dart';
import '../../../util/date/date_util.dart';
import '../../../util/dialog/dialog_util.dart';
import '../../../util/integer/integer_util.dart';
import '../../../util/keyboard/keyboard_util.dart';
import '../../../viewmodel/comment/delete/delete_comment_viewmodel.dart';
import '../../../viewmodel/comment/list/comment_list_viewmodel.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({Key? key, required this.commentModel}) : super(key: key);

  final CommentModel commentModel;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  late CommentListViewModel commentListViewModel;
  late DeleteCommentViewModel deleteCommentViewModel;

  @override
  void initState() {
    super.initState();

    initViewModels();
  }

  initViewModels() {
    commentListViewModel = context.read<CommentListViewModel>();
    deleteCommentViewModel = DeleteCommentViewModel(deleteCommentUseCase: GetIt.instance<DeleteCommentUseCase>());
  }

  @override
  Widget build(BuildContext context) {
    const double constantPadding = 12;
    String dateString = widget.commentModel.createdAt != null ? widget.commentModel.createdAt.toString() : "";

    return MultiProvider(
      providers: [
        Provider<DeleteCommentViewModel>(
          create: (context) => deleteCommentViewModel,
        ),
      ],
      child: Container(
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
                    Text(
                      "${widget.commentModel.getChildrenCount} comment${IntegerUtil().getPluralSuffix(count: widget.commentModel.getChildrenCount)}",
                      style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.blueAccent),
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
                    KeyboardUtil().dismissKeyboard(context),
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
      secondButtonListener:
          () {}, // TODO : Edit comment feature implementation
    );
  }

  void deleteCommentConfirmModal() {
    showTwoButtonDialog(
        context: context,
        title: deleteComment,
        content: deleteCommentConfirm,
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
    final state = await deleteCommentViewModel.deleteComment(commentId: commentId);
    if (state is Success) {
      if (context.mounted) showCustomToastWithTimer(context: context, message: "The comment has been deleted");
      /// Remove the deleted comment from the list
      commentListViewModel.removeDeletedCommentFromList(commentId: commentId);
    }
  }
}
