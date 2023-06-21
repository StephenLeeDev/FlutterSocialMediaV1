import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/common/common_state.dart';
import '../../../../data/model/post/post_model.dart';
import '../../../viewmodel/post/post_list_viewmodel.dart';
import '../../../viewmodel/user/bookmark_viewmodel.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {

  late final BookmarkViewModel bookmarkViewModel;
  late final PostListViewModel postListViewModel;

  @override
  void initState() {
    super.initState();
    bookmarkViewModel = context.read<BookmarkViewModel>();
    // TODO : Updated post item setter implementation
    postListViewModel = context.read<PostListViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    const double constantPadding = 12;
    bool isBookmarked = widget.postModel.isBookmarked ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            GestureDetector(
              // TODO : Implement moving to the user's detail screen feature
              onTap: () {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(constantPadding),
                    width: 30,
                    height: 30,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      widget.postModel.user?.thumbnail ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    widget.postModel.getUserName(),
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // TODO : Implement follow/unfollow feature
            // TODO : This icon button should be invisible on the user's own post
            IconButton(
                onPressed: null,
                icon: const Icon(Icons.more_vert_rounded, color: Colors.black))
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
                widget.postModel.isLiked == true ? Icons.favorite : Icons.favorite_outline_outlined,
                color: widget.postModel.isLiked == true ? Colors.redAccent : Colors.black,
              ),
              onPressed: () async {
                // TODO : Implement like/unlike feature
              },
            ),
            IconButton(
              padding: EdgeInsets.zero,
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
              padding: EdgeInsets.zero,
              icon: Icon(
                isBookmarked == true ? Icons.bookmark : Icons.bookmark_border_rounded,
                color: Colors.black,
              ),
              onPressed: () async {
                final postId = widget.postModel.id;
                if (postId == null) return;

                /// Request update the bookmark to the app server
                final result = await bookmarkViewModel.postBookmark(postId: postId);
                if (result is Success) {
                  postListViewModel.setUpdatedBookmark(postId: postId);
                  /// Update current post widget
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                }
              },
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.only(left: constantPadding, right: constantPadding, bottom: constantPadding),
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
                            text: widget.postModel.getUserName(),
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

              // TODO : Implement a date information feature
              // TODO : Implement comments feature
            ],
          ),
        )
      ],
    );
  }
}
