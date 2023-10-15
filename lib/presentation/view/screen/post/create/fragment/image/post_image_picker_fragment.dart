import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../values/text/text.dart';
import '../../../../../../util/dialog/dialog_util.dart';
import '../../../../../../util/integer/integer_util.dart';
import '../../../../../../util/logger/image_file_logger_util.dart';
import '../../../../../../viewmodel/post/create/create_post_viewmodel.dart';
import '../../../../../widget/common/button/custom_animated_button.dart';

class PostImagePickerFragment extends StatefulWidget {
  const PostImagePickerFragment({Key? key}) : super(key: key);

  @override
  State<PostImagePickerFragment> createState() => _PostImagePickerFragmentState();
}

class _PostImagePickerFragmentState extends State<PostImagePickerFragment> {
  static const double maxImageLength = 1000;
  static const int maxImageCount = 4;

  late final CreatePostViewModel _createPostViewModel;

  final ImagePicker imagePicker = ImagePicker();
  late final PageController _pageController;

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
            maxQuantityMessage,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),

          /// Image picker button
          GestureDetector(
            onTap: () {
              /// Can add up to 4 images
              if (_createPostViewModel.imageList.length < maxImageCount) {
                showSelectionGalleryCameraDialog();
              } else {
                showMaxWarningDialog();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.photo_camera,
                    color: Colors.black,
                  ),
                  SizedBox(width: 4),
                  Text(
                    selectPictures,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: constantPadding),

          /// Image list view
          Expanded(
            child: ValueListenableBuilder<List<XFile>>(
                valueListenable: _createPostViewModel.imageListNotifier,
                builder: (context, list, _) {
                  /// List view
                  if (list.isNotEmpty) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: constantPadding,
                        mainAxisSpacing: constantPadding,
                      ),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        /// Image item view
                        return Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.file(
                                  File(list[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            /// Remove image button
                            Positioned(
                              right: 0,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete_forever_rounded),
                                  onPressed: () {
                                    /// Remove this image
                                    _createPostViewModel.removeImageFromListByIndex(index: index);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    /// Empty list message view
                    return const Center(
                      child: Text(
                        pleaseSelectPictures,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
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

  // TODO : Must test image picker features on actual iOS device later (I don't have Apple developer account yet)
  /// Show image source selection dialog between camera/gallery
  void showSelectionGalleryCameraDialog() {
    showTwoButtonDialog(
      context: context,
      title: selectOption,
      message: selectPictureSource,
      firstButtonText: gallery,

      /// Pick images from gallery
      firstButtonListener: () async {
        var images = await pickImagesFromGallery();

        final currentImages = _createPostViewModel.imageList.length;
        final additionalImages = images.length;

        if (currentImages + additionalImages > maxImageCount) {
          final availableCountToAdd = maxImageCount - currentImages;

          images = images.sublist(0, availableCountToAdd);
          showExceedWarningDialog(count: availableCountToAdd);
        }
        _createPostViewModel.addAdditionalImagesToList(list: images);
      },

      /// Pick an image from camera
      secondButtonText: camera,
      secondButtonListener: () async {
        var images = await pickImageFromCamera();
        _createPostViewModel.addAdditionalImagesToList(list: images);
      },
    );
  }

  // TODO : Refactor this feature as a module
  /// Pick a single image from the camera.
  Future<List<XFile>> pickImageFromCamera() async {
    final XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: maxImageLength,
        maxWidth: maxImageLength);

    /// It prints image file's information
    if (kDebugMode && image != null) {
      await printImageInfo(fileName: image.name, file: File(image.path));
    }

    return image != null ? [image] : [];
  }

  // TODO : Refactor this feature as a module
  /// Pick multiple images from the gallery.
  Future<List<XFile>> pickImagesFromGallery() async {
    final List<XFile> images = await imagePicker.pickMultiImage(
        maxHeight: maxImageLength, maxWidth: maxImageLength);

    /// It prints image file's information
    if (kDebugMode) {
      for (int i = 0; i < images.length; i++) {
        await printImageInfo(
            fileName: images[i].name, file: File(images[i].path));
      }
    }

    return images;
  }

  /// Next button
  Widget bottomButtons() {
    return ValueListenableBuilder<List<XFile>>(
      valueListenable: _createPostViewModel.imageListNotifier,
      builder: (context, list, _) {
        final isEnabled = list.isNotEmpty;
        return CustomAnimatedButton(
          text: next,
          isEnabled: isEnabled,
          onPositiveListener: () {
            /// Move to the next page
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        );
      },
    );
  }

  /// Warning : Already picked maximum pictures
  void showMaxWarningDialog() {
    showTwoButtonDialog(
      context: context,
      title: warning,
      message: canAddUpToFourPictures,

      firstButtonText: ok,
      firstButtonListener: () {},
    );
  }

  /// Warning : Picked exceeds pictures
  void showExceedWarningDialog({required int count}) {
    showTwoButtonDialog(
      context: context,
      title: warning,
      message: "$canAddUpToFourPictures\n\nAdded only $count picture${IntegerUtil().getPluralSuffix(count: count)} from your select",

      firstButtonText: ok,
      firstButtonListener: () {},
    );
  }

}
