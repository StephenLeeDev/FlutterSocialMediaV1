import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../../../data/model/post/post_model.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(postModel.user?.thumbnail ?? ""),
            ),
            Text(postModel.user?.username ?? "Unknown"),
          ],
        ),
        Container(
          color: Colors.black,
          child: ImageSlideshow(
            width: double.infinity,
            height: MediaQuery.of(context).size.width,
            initialPage: 0,
            indicatorColor: postModel.imageUrls?.length == 1 ? Colors.transparent : Colors.blue,
            indicatorBackgroundColor: postModel.imageUrls?.length == 1 ? Colors.transparent : Colors.grey,
            children: postModel.imageUrls?.map((imageUrl) {
              return Image.network(
                imageUrl,
                fit: BoxFit.contain,
              );
            }).toList() ?? [],
          ),
        ),
        Column(
          children: [
            Text(postModel.description ?? ""),
          ],
        )
      ],
    );
  }
}
