import 'package:flutter/material.dart';

import '../../../../data/model/post/item/post_model.dart';

/// Feed item for grid feed screen
class PostGridWidget extends StatelessWidget {
  const PostGridWidget({
    Key? key,
    required this.postModel,
    this.isFromMyPage = false,
    required this.onTap,
  }) : super(key: key);

  final PostModel postModel;
  final bool isFromMyPage;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Image.network(
        postModel.getFirstImage,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}
