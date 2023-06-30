import 'package:flutter/material.dart';

import '../../../../data/model/comment/comment_model.dart';
import '../../../util/date/date_util.dart';
import '../../../util/integer/integer_util.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({Key? key, required this.commentModel}) : super(key: key);

  final CommentModel commentModel;

  @override
  Widget build(BuildContext context) {

    const double constantPadding = 12;
    String dateString = commentModel.createdAt != null ? commentModel.createdAt.toString() : "";

    return Container(
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
                commentModel.user?.thumbnail ?? "",
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        commentModel.getUserName,
                        style: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.black45),
                      ),
                      Text(
                        "  ${DateUtil().getTimeAgo(dateString)}",
                        style: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.black45),
                      ),
                    ],
                  ),
                  Text(
                    commentModel.getContent,
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(height: constantPadding),
                  Text(
                    "${commentModel.getChildrenCount} comment${IntegerUtil().getPluralSuffix(count: commentModel.getChildrenCount)}",
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueAccent),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
