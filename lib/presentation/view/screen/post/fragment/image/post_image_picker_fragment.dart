import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../data/constant/text.dart';
import '../../../../../../domain/usecase/post/create/create_post_usecase.dart';
import '../../../../../util/dialog/dialog_util.dart';
import '../../../../../util/logger/image_file_logger_util.dart';
import '../../../../../viewmodel/post/create/create_post_viewmodel.dart';

class PostImagePickerFragment extends StatefulWidget {
  const PostImagePickerFragment({Key? key}) : super(key: key);

  @override
  State<PostImagePickerFragment> createState() =>
      _PostImagePickerFragmentState();
}

class _PostImagePickerFragmentState extends State<PostImagePickerFragment> {
  static const double maxImageLength = 1000;

  late final CreatePostViewModel _createPostViewModel;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _createPostViewModel = CreatePostViewModel(createPostUseCase: GetIt.instance<CreatePostUseCase>());
  }

  @override
  Widget build(BuildContext context) {
    const double constantPadding = 12;

    /// Provider
    return MultiProvider(
      providers: [
        Provider<CreatePostViewModel>(
          create: (context) => _createPostViewModel,
        ),
      ],

      /// Screen
      child: Padding(
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

            /// image picker button
            GestureDetector(
              onTap: () {
                showSelectionGalleryCameraDialog();
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
                          return AspectRatio(
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
                          );
                        },
                      );
                    } else {
                      /// Empty list message
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
                  }),
            ),

            // TODO : Implement next button UI & feature

          ],
        ),
      ),
    );
  }

  // TODO : Must test image picker features on actual iOS device later (I don't have Apple developer account yet)
  /// Show image source selection dialog between camera/gallery
  void showSelectionGalleryCameraDialog() {
    showTwoButtonDialog(
      context: context,
      title: selectOption,
      content: selectPictureSource,
      firstButtonText: gallery,

      /// Pick image from gallery
      firstButtonListener: () async {
        var images = await pickImagesFromGallery();
        _createPostViewModel.setImageList(list: images);
      },

      /// Pick image from camera
      secondButtonText: camera,
      secondButtonListener: () async {
        var images = await pickImageFromCamera();
        _createPostViewModel.setImageList(list: images);
      },
    );
  }

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
}
