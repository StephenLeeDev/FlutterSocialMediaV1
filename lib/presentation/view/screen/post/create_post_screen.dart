import 'package:flutter/material.dart';

import '../../../../data/constant/text.dart';
import 'fragment/description/post_description_fragment.dart';
import 'fragment/image/post_image_picker_fragment.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  static const String routeName = "createPost";
  static const String routeURL = "/post/create";

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  final List<Widget> fragments = [
    const PostImagePickerFragment(),
    const PostDescriptionFragment(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      /// Appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          createPost,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      /// PageView screen
      /// ImagePicker, and Description fragments
      body: PageView.builder(
        itemCount: fragments.length,
        itemBuilder: (context, index) {
          return fragments[index];
        },
      ),
    );
  }

}
