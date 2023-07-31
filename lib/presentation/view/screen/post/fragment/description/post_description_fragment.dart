import 'package:flutter/material.dart';

class PostDescriptionFragment extends StatefulWidget {
  const PostDescriptionFragment({Key? key}) : super(key: key);

  @override
  State<PostDescriptionFragment> createState() =>
      _PostDescriptionFragmentState();
}

class _PostDescriptionFragmentState extends State<PostDescriptionFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Description fragment",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 18,
        ),
      ),
    );
  }
}
