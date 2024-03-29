import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../values/text/text.dart';
import '../../../../data/model/common/common_state.dart';
import '../../../../data/model/common/single_integer_state.dart' as SingleIntegerState;
import '../../../../data/model/post/item/post_model.dart';
import '../../../../domain/usecase/post/delete/delete_post_usecase.dart';
import '../../../../domain/usecase/post/like/post_like_usecase.dart';
import '../../../../domain/usecase/user/current_user/post_bookmark_usecase.dart';
import '../../../util/bottom_sheet/bottom_sheet_util.dart';
import '../../../util/custom_toast/custom_toast_util.dart';
import '../../../util/date/date_util.dart';
import '../../../util/dialog/dialog_util.dart';
import '../../../util/integer/integer_util.dart';
import '../../../util/snackbar/snackbar_util.dart';
import '../../../viewmodel/post/delete/delete_post_viewmodel.dart';
import '../../../viewmodel/post/like/post_like_viewmodel.dart';
import '../../../viewmodel/post/list/current_user_post_grid_list_viewmodel.dart';
import '../../../viewmodel/post/list/post_list_viewmodel.dart';
import '../../../viewmodel/user/current_user/bookmark/bookmark_viewmodel.dart';
import '../../screen/comment/comment/comment_screen.dart';
import '../../screen/post/update/update_post_description_screen.dart';
import '../../screen/user/user_detail_screen.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key, required this.postModel, this.isAbleToMoveUserDetailScreen = true}) : super(key: key);
  final PostModel postModel;
  final bool isAbleToMoveUserDetailScreen;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late final BookmarkViewModel _bookmarkViewModel;
  late final PostListViewModel _postListViewModel;
  late final DeletePostViewModel _deletePostViewModel;
  late final PostLikeViewModel _postLikeViewModel;
  late final CurrentUserPostGridListViewModel _postGridListViewModel;

  @override
  void initState() {
    super.initState();

    initViewModels();
  }

  /// ViewModels
  void initViewModels() {
    initListViewModel();
    initGridListViewModel();
    initBookmarkViewModel();
    initLikeViewModel();
    initDeleteViewModel();
  }

  /// List
  void initListViewModel() {
    _postListViewModel = context.read<PostListViewModel>();
  }

  /// Grid Feed List
  void initGridListViewModel() {
    _postGridListViewModel = context.read<CurrentUserPostGridListViewModel>();
  }

  /// Bookmark
  void initBookmarkViewModel() {
    _bookmarkViewModel = BookmarkViewModel(postBookmarkUseCase: GetIt.instance<PostBookmarkUseCase>());
  }

  /// Like/Unlike
  void initLikeViewModel() {
    _postLikeViewModel = PostLikeViewModel(postLikeUseCase: GetIt.instance<PostLikeUseCase>());
  }

  /// Delete
  void initDeleteViewModel() {
    _deletePostViewModel = DeletePostViewModel(deletePostUseCase: GetIt.instance<DeletePostUseCase>());
  }

  @override
  Widget build(BuildContext context) {

    const double constantPadding = 12;

    bool? isBookmarked = widget.postModel.isBookmarked;
    bool? isLiked = widget.postModel.isLiked;
    int likeCount = widget.postModel.likeCount ?? 0;
    int commentCount = widget.postModel.commentCount ?? 0;

    String dateString = widget.postModel.createdAt != null ? widget.postModel.createdAt.toString() : "";

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  /// Description for the [!widget.postModel.isMine] flag
                  /// Move to the UserDetailScreen when it's not the current user's post
                  /// The UserDetailScreen is not for the current user
                  /// The current user should use MyPageScreen
                  ///
                  /// Description for the [widget.isAbleToMoveUserDetailScreen] flag
                  /// Shouldn't move to the UserDetailScreen when the current location is the FeedFragment
                  /// Because if it is possible, then it causes the infinite loop screens issue
                  ///
                  /// Overall, moving screens is allowed only when meet both conditions for the above flags
                  final isAbleToMove = !widget.postModel.isMine && widget.isAbleToMoveUserDetailScreen;
                  if (isAbleToMove) {
                    context.pushNamed(
                      UserDetailScreen.routeName,
                      queryParameters: {
                        'userEmail': widget.postModel.getUserEmail,
                      },
                    );
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// User thumbnail
                    Container(
                      margin: const EdgeInsets.all(constantPadding),
                      width: 30,
                      height: 30,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network(
                        widget.postModel.getUserThumbnail,
                        fit: BoxFit.cover,
                      ),
                    ),
                    /// User name
                    Text(
                      widget.postModel.getUserName,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              /// It is visible when it's the user's own post
              if (widget.postModel.isMine)
              IconButton(
                  onPressed: () => {
                    /// Show Edit/Delete bottom sheet
                    showEditDeleteBottomModal()
                  },
                  icon: const Icon(Icons.more_vert_rounded, color: Colors.black),
              ),
            ],
          ),
          Container(
            color: Colors.black,
            child: ImageSlideshow(
              width: double.infinity,
              height: MediaQuery.of(context).size.width,
              initialPage: 0,
              indicatorColor: widget.postModel.imageUrls?.length == 1
                  ? Colors.transparent
                  : Colors.blue,
              indicatorBackgroundColor: widget.postModel.imageUrls?.length == 1
                  ? Colors.transparent
                  : Colors.grey,
              children: widget.postModel.imageUrls?.map((imageUrl) {
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                    );
                  }).toList() ??
                  [],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked == true
                      ? Icons.favorite
                      : Icons.favorite_outline_outlined,
                  color: isLiked == true ? Colors.redAccent : Colors.black,
                ),
                onPressed: () async {
                  final postId = widget.postModel.id;
                  if (postId == null || isLiked == null) return;

                  /// Request update the like/unlike to the app server
                  final result = await _postLikeViewModel.postLike(postId: postId);
                  if (result is SingleIntegerState.Success) {
                    final newLikeCount = result.getValue;

                    widget.postModel.setLike();
                    widget.postModel.setLikeCount(value: newLikeCount);
                    _postListViewModel.replaceUpdatedItemFromList(updatedPost: widget.postModel);
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.black,
                ),
                onPressed: () async {
                  // TODO : Implement create/move a chatroom
                },
              ),
              const Spacer(),

              /// Bookmark/unbookmark button
              IconButton(
                icon: Icon(
                  isBookmarked == true
                      ? Icons.bookmark
                      : Icons.bookmark_border_rounded,
                  color: Colors.black,
                ),
                onPressed: () async {
                  final postId = widget.postModel.id;
                  if (postId == null || isBookmarked == null) return;

                  /// Request update the bookmark/unbookmark to the app server
                  final result =
                      await _bookmarkViewModel.postBookmark(postId: postId);
                  if (result is Success) {
                    widget.postModel.setBookmark();
                    _postListViewModel.replaceUpdatedItemFromList(updatedPost: widget.postModel);
                  }
                },
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: constantPadding, bottom: constantPadding),
            child: Text(
              "$likeCount like${IntegerUtil().getPluralSuffix(count: likeCount)}",
              style: const TextStyle(
                  fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
                left: constantPadding,
                right: constantPadding,
                bottom: constantPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.postModel.getUserName,
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: widget.postModel.description ?? "",
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              final postId = widget.postModel.getId;
              if (postId > 0) context.pushNamed(CommentScreen.routeName, queryParameters: {'postId': "$postId"});
            },
            child: Padding(
              padding: const EdgeInsets.only(left: constantPadding, bottom: constantPadding),
              child: Text(
                "View $commentCount comment${IntegerUtil().getPluralSuffix(count: commentCount)}",
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black),
              ),
            ),
          ),

          if (dateString.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: constantPadding, bottom: constantPadding),
            child: Text(
              DateUtil().getTimeAgo(dateString),
              style: const TextStyle(
                  fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.black45),
            ),
          ),

        ],
      ),
    );
  }

  // TODO : Low priority
  // TODO : Refactor this feature with the [showMultiButtonBottomSheetCupertino] module
  void showEditDeleteBottomModal() {
    showTwoButtonBottomSheetCupertino(
      context: context,
      title: post,

      /// Delete button
      firstButtonIcon: Icons.delete_forever,
      firstButtonText: delete,
      firstButtonListener: () {
        deletePostConfirmModal();
      },
      /// Edit description button
      secondButtonIcon: Icons.edit,
      secondButtonText: edit,
      secondButtonListener: () {
        updatePostDescription();
      },
    );
  }

  void deletePostConfirmModal() {
    showTwoButtonDialog(
      context: context,
      title: deletePost,
      message: deletePostConfirm,
      /// Delete button
      firstButtonText: delete,
      firstButtonListener: () {
        deletePostFeature();
      },
      /// Cancel button
      secondButtonText: cancel,
    );
  }

  void deletePostFeature() async {
    final postId = widget.postModel.id ?? -1;
    /// Delete the post
    final state = await _deletePostViewModel.deletePost(postId: postId);
    if (state is Success) {
      if (context.mounted) showCustomToastWithTimer(context: context, message: postDeletedMessage);
      /// Remove the deleted post from the list
      _postListViewModel.removeDeletedPostFromList(postId: postId);
      _postGridListViewModel.removeDeletedPostFromList(postId: postId);
    }
  }

  void updatePostDescription() async {
    String? updatedPost = await context.pushNamed(
      UpdatePostDescriptionScreen.routeName,
      queryParameters: {
        PostModel().getSimpleName(): jsonEncode(widget.postModel),
      },
    );
    /// If updated post exists, replace the item from the list
    if (updatedPost != null) {
      _postListViewModel.replaceUpdatedItemFromList(updatedPost: PostModel.fromJson(jsonDecode(updatedPost)));
      _postGridListViewModel.replaceUpdatedItemFromList(updatedPost: PostModel.fromJson(jsonDecode(updatedPost)));
      if (context.mounted) showSnackBar(context: context, text: postUpdatedMessage);
    }
  }

}
