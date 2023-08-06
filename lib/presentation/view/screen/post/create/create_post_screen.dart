import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../../data/constant/text.dart';
import '../../../../../domain/usecase/post/create/create_post_usecase.dart';
import '../../../../util/dialog/dialog_util.dart';
import '../../../../viewmodel/post/create/create_post_viewmodel.dart';
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

  late final CreatePostViewModel _createPostViewModel;

  final PageController _pageController = PageController();

  final List<Widget> fragments = [
    const PostImagePickerFragment(),
    const PostDescriptionFragment(),
  ];

  @override
  void initState() {
    super.initState();

    initCreateViewModel();
  }

  /// Create
  void initCreateViewModel() {
    _createPostViewModel = CreatePostViewModel(createPostUseCase: GetIt.instance<CreatePostUseCase>());
  }

  @override
  Widget build(BuildContext context) {

    /// Provider
    return MultiProvider(
      providers: [
        Provider<CreatePostViewModel>(
          create: (context) => _createPostViewModel,
        ),
        ListenableProvider<PageController>(
          create: (context) => _pageController,
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
            createPost,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          /// onBackPressed
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              showConfirmCancelDialog();
            },
          ),
        ),
        /// PageView screen
        /// ImagePicker, and Description fragments
        body: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fragments.length,
          itemBuilder: (context, index) {
            return fragments[index];
          },
        ),
      ),
    );
  }

  void showConfirmCancelDialog() {
    showTwoButtonDialog(
      context: context,
      title: areYouSure,
      content: quitPostWritingConfirm,

      /// Keep writing
      firstButtonText: keepWriting,
      firstButtonListener: () {},

      /// Confirm
      secondButtonText: confirm,
      secondButtonListener: () {
        if (context.mounted) Navigator.pop(context);
      },
    );
  }

}
