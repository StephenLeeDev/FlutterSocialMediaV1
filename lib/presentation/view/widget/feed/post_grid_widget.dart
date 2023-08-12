import 'package:flutter/material.dart';

import '../../../../data/model/post/item/post_model.dart';

class PostGridWidget extends StatefulWidget {
  const PostGridWidget({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;

  @override
  State<PostGridWidget> createState() => _PostGridWidgetState();
}

class _PostGridWidgetState extends State<PostGridWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.postModel.getFirstImage,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
  }
}
