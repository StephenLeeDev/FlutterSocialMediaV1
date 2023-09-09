import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../values/text/text.dart';
import '../../../../../../../data/model/post/item/post_item_state.dart';
import '../../../../../../viewmodel/post/create/create_post_viewmodel.dart';
import '../../../../../widget/common/button/custom_animated_button.dart';
import '../../../../../widget/common/button/rounded_elevated_button.dart';

class PostDescriptionFragment extends StatefulWidget {
  const PostDescriptionFragment({Key? key}) : super(key: key);

  @override
  State<PostDescriptionFragment> createState() =>
      _PostDescriptionFragmentState();
}

class _PostDescriptionFragmentState extends State<PostDescriptionFragment> {

  late final CreatePostViewModel _createPostViewModel;

  late final PageController _pageController;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initCreateViewModel();
    initPageController();
  }

  /// Create
  void initCreateViewModel() {
    _createPostViewModel = context.read<CreatePostViewModel>();
  }

  /// PageController
  void initPageController() {
    _pageController = context.read<PageController>();
  }

  @override
  Widget build(BuildContext context) {
    const double constantPadding = 12;

    return Padding(
      padding: const EdgeInsets.all(constantPadding),
      child: Column(
        children: [
          /// Guide message
          const Text(
            pleaseWriteDescription,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),

          /// Text field
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: writeDescription,
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
              maxLength: 200,
              onChanged: (value) {
                /// Set description
                _createPostViewModel.setDescription(value: value);
              },
            ),
          ),

          const SizedBox(height: 12),

          /// Bottom buttons
          bottomButtons(),
        ],
      ),
    );
  }

  Widget bottomButtons() {
    return Row(
      children: [
        /// Previous
        Flexible(
          flex: 1,
          child: RoundedElevatedButton(
            text: previous,
            onPressed: () {
              /// Move to the previous page
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        /// Create
        Flexible(
          flex: 2,
          child: ValueListenableBuilder<bool>(
            valueListenable: _createPostViewModel.isValidNotifier,
            builder: (context, isValid, _) {
              return CustomAnimatedButton(
                text: create,
                isEnabled: isValid,
                onPositiveListener: () async {
                  /// Create a new post
                  final state = await _createPostViewModel.createPost();
                  if (state is Success) {
                    if (context.mounted) Navigator.pop(context, jsonEncode(state.getItem));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
