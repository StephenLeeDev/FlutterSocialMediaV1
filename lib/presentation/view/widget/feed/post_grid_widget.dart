import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/model/post/item/post_model.dart';
import '../../screen/feed/feed_screen_from_grid.dart';

/// Feed item for grid feed screen
class PostGridWidget extends StatelessWidget {
  const PostGridWidget({
    Key? key,
    required this.postModel,
    this.isFromMyPage = false,
  }) : super(key: key);

  final PostModel postModel;
  final bool isFromMyPage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isFromMyPage) {
          context.pushNamed(
              FeedScreenFromGrid.routeName,
              queryParameters: {
                "postId": "${postModel.getId}",
                "title": "${postModel.getUserName}'s feed",
              }
          );
        } else {
          // TODO : Implement other user's feed screen
        }
      },
      child: Image.network(
        postModel.getFirstImage,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}
