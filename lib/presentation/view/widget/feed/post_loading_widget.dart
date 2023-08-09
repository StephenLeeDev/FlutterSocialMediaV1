import 'package:flutter/material.dart';

class PostLoadingWidget extends StatelessWidget {
  const PostLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double constantPadding = 12;
    const double constantPaddingFour = 4;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
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
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(constantPaddingFour),
                      width: 60,
                      height: 15,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(constantPaddingFour),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width,
            color: Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.all(constantPadding),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: constantPadding * 2),
                Icon(
                  Icons.send_rounded,
                  color: Colors.grey.shade300,
                ),
                const Spacer(),

                /// Bookmark/unbookmark button
                Icon(
                  Icons.bookmark,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: constantPadding, bottom: constantPadding),
            child: Container(
              width: 60,
              height: 15,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(constantPaddingFour),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: constantPadding,
              right: constantPadding,
              bottom: constantPadding,
            ),
            child: Container(
              width: 200,
              height: 15,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(constantPaddingFour),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: constantPadding,
              bottom: constantPadding,
            ),
            child: Container(
              width: 200,
              height: 15,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(constantPaddingFour),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: constantPadding,
            ),
            child: Container(
              width: 100,
              height: 15,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(constantPaddingFour),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
