import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../../../data/model/post/post_model.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {

    const double constantPadding = 8;

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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(postModel.user?.thumbnail ?? ""),
                  ),
                  Text(
                    postModel.getUserName(),
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
            indicatorColor: postModel.imageUrls?.length == 1
                ? Colors.transparent
                : Colors.blue,
            indicatorBackgroundColor: postModel.imageUrls?.length == 1
                ? Colors.transparent
                : Colors.grey,
            children: postModel.imageUrls?.map((imageUrl) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  );
                }).toList() ??
                [],
          ),
        ),
        // TODO : Implement like/unlike feature & view
        Padding(
          padding: const EdgeInsets.all(constantPadding),
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
                            text: postModel.getUserName(),
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: postModel.description ?? "",
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                                color: Colors.black
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),

              // TODO : Implement a date information feature
            ],
          ),
        )
      ],
    );
  }
}
