import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/post/item/post_item_state.dart';
import '../../../../values/text/text.dart';
import '../../../../../data/model/post/item/post_model.dart';
import '../../../../../domain/usecase/post/update/update_post_description_usecase.dart';
import '../../../../viewmodel/post/update/update_post_description_viewmodel.dart';
import '../../../widget/common/button/custom_elevated_button.dart';

class UpdatePostDescriptionScreen extends StatefulWidget {
  const UpdatePostDescriptionScreen({Key? key, required this.postString}) : super(key: key);

  static const String routeName = "updatePostDescription";
  static const String routeURL = "/post/description";

  final String postString;

  @override
  State<UpdatePostDescriptionScreen> createState() => _UpdatePostDescriptionScreenState();
}

class _UpdatePostDescriptionScreenState extends State<UpdatePostDescriptionScreen> {

  late final UpdatePostDescriptionViewModel _updatePostDescriptionViewModel;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initViewModels();
  }

  /// Update
  void initViewModels() {
    _updatePostDescriptionViewModel = UpdatePostDescriptionViewModel(updatePostDescriptionUseCase: GetIt.instance<UpdatePostDescriptionUseCase>());
    initData();
  }

  void initData() {
    if (widget.postString.isNotEmpty) {
      final post = PostModel.fromJson(jsonDecode(widget.postString));
      _updatePostDescriptionViewModel.setPostId(value: post.getId);
      _updatePostDescriptionViewModel.setPreviousDescription(value: post.getDescription);
      _textEditingController.text = post.getDescription;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double constantPadding = 12;

    /// Provider
    return MultiProvider(
      providers: [
        Provider<UpdatePostDescriptionViewModel>(
          create: (context) => _updatePostDescriptionViewModel,
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        /// Appbar
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          title: const Text(
            updatePostDescription,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        /// Screen
        body: Padding(
          padding: const EdgeInsets.all(constantPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Guide message
              const Text(
                pleaseWriteNewDescription,
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
                    _updatePostDescriptionViewModel.setDescription(value: value);
                  },
                ),
              ),

              const SizedBox(height: 12),

              /// Bottom buttons
              bottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomButtons() {
    return SafeArea(
      child: Row(
        children: [
          /// Update
          Flexible(
            flex: 2,
            child: ValueListenableBuilder<bool>(
              valueListenable: _updatePostDescriptionViewModel.isValidNotifier,
              builder: (context, isValid, _) {
                return CustomAnimatedButton(
                  text: update,
                  isEnabled: isValid,
                  onPositiveListener: () async {
                    /// Update the post's description
                    final state = await _updatePostDescriptionViewModel.updatePost();

                    if (state is Success) {
                      if (context.mounted) Navigator.pop(context, jsonEncode(state.getItem));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
