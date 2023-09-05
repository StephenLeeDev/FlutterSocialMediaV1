import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../values/text/text.dart';
import '../../../../data/model/common/common_state.dart' as CommonState;
import '../../../../data/model/common/single_string_state.dart' as SingleStringState;
import '../../../../data/model/post/item/post_model.dart';
import '../../../../data/model/post/list/post_list_state.dart' as PostListState;
import '../../../../data/model/user/my_user_info_state.dart' as MyUserInfoState;
import '../../../../domain/usecase/user/current_user/update_user_status_message_usecase.dart';
import '../../../../domain/usecase/user/current_user/update_user_thumbnail_usecase.dart';
import '../../../util/dialog/dialog_util.dart';
import '../../../util/logger/image_file_logger_util.dart';
import '../../../util/snackbar/snackbar_util.dart';
import '../../../viewmodel/post/list/current_user_post_grid_list_viewmodel.dart';
import '../../../viewmodel/post/list/post_list_viewmodel.dart';
import '../../../viewmodel/user/current_user/get_user_info/current_user_info_viewmodel.dart';
import '../../../viewmodel/user/current_user/update/update_status_message_viewmodel.dart';
import '../../../viewmodel/user/current_user/update/update_thumbnail_viewmodel.dart';
import '../../widget/common/error/error_widget.dart';
import '../../widget/feed/post_grid_widget.dart';
import '../feed/feed_screen_from_grid.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  static const String routeName = "myPage";
  static const String routeURL = "/myPage";

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  static const double maxImageLength = 1000;

  final ImagePicker imagePicker = ImagePicker();
  final _scrollController = ScrollController();

  late final CurrentUserInfoViewModel _myUserInfoViewModel;
  late final CurrentUserPostGridListViewModel _postListViewModel;
  late final UpdateUserThumbnailViewModel _updateUserThumbnailViewModel;
  late final UpdateUserStatusMessageViewModel _updateUserStatusMessageViewModel;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    initViewModels();
    fetchData(); // TODO : Move MyPostGridListViewModel to MainNavigationScreen, and synchronize it with getPostList() between MyPostGridListViewModel and PostListViewModel.
  }

  /// ViewModels
  void initViewModels() {
    initMyUserInfoViewModel();
    initListViewModel();
    initUpdateUserThumbnailViewModel();
    initUpdateUserStatusMessageViewModel();
  }

  /// My User Info
  void initMyUserInfoViewModel() {
    _myUserInfoViewModel = GetIt.instance<CurrentUserInfoViewModel>();
  }

  /// List
  void initListViewModel() {
    _postListViewModel = context.read<CurrentUserPostGridListViewModel>();
  }

  /// Update user thumbnail
  void initUpdateUserThumbnailViewModel() {
    _updateUserThumbnailViewModel = UpdateUserThumbnailViewModel(
        updateThumbnailUseCase: GetIt.instance<UpdateUserThumbnailUseCase>(),
    );
  }

  /// Update user status message
  void initUpdateUserStatusMessageViewModel() {
    _updateUserStatusMessageViewModel = UpdateUserStatusMessageViewModel(
        updateStatusMessageUseCase: GetIt.instance<UpdateUserStatusMessageUseCase>(),
    );
  }

  void fetchData() async {
    await fetchPostList();
  }

  /// Fetch feed
  Future<void> fetchPostList() async {
    await _postListViewModel.getPostList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<PostListViewModel>(
          create: (context) => _postListViewModel,
        ),
        Provider<CurrentUserInfoViewModel>(
          create: (context) => _myUserInfoViewModel,
        ),
      ],

      /// Screen
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return _refresh();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: [
              /// User profile
              ValueListenableBuilder<MyUserInfoState.MyUserInfoState>(
                valueListenable: _myUserInfoViewModel.myUserInfoStateNotifier,
                builder: (context, state, _) {
                  if (state is MyUserInfoState.Success) {
                    return buildUserProfileUI();
                  } else {
                    // TODO : Implement Loading UI
                    return Container();
                  }
                },
              ),

              /// Grid feed
              ValueListenableBuilder<PostListState.PostListState>(
                valueListenable: _postListViewModel.postListStateNotifier,
                builder: (context, state, _) {

                  /// Loading UI
                  if ((state is PostListState.Loading && _postListViewModel.currentList.isEmpty)) {
                    return buildLoadingStateUI();
                  }

                  /// Fail UI
                  else if (state is PostListState.Fail) {
                    return buildFailStateUI();
                  }

                  /// Success UI (default)
                  else {
                    return buildSuccessStateUI();
                  }

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO : Low priority
  // TODO : Replace this function as a widget later
  /// User profile layout
  Widget buildUserProfileUI() {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Appbar
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
                child: Row(
                  children: [
                    /// User's name
                    ValueListenableBuilder<String>(
                      valueListenable: _myUserInfoViewModel.myUsernameNotifier,
                      builder: (context, name, _) {
                        return Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w900,
                          ),
                        );
                      },
                    ),
                    const Spacer(),

                    /// Pop up menu
                    // TODO : Mid priority
                    // TODO : Modify with showTwoButtonBottomSheetCupertino() for enhance
                    popUpMenuWidget(),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  /// User thumbnail
                  GestureDetector(
                    onTap: () {
                      showSelectionGalleryCameraDialog();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 0),
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ValueListenableBuilder<String>(
                        valueListenable: _myUserInfoViewModel.thumbnailNotifier,
                        builder: (context, thumbnail, _) {
                          return Image.network(
                            thumbnail,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// Posts
                        Expanded(
                          child: Column(
                            children: [
                              /// Total posts count
                              ValueListenableBuilder<int>(
                                valueListenable: _myUserInfoViewModel.totalPostCountNotifier,
                                builder: (context, total, _) {
                                  return Text(
                                    "$total",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                              const Text(
                                "Posts",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Followers
                        Expanded(
                          child: Column(
                            children: [
                              /// Total follower count
                              ValueListenableBuilder<int>(
                                valueListenable: _myUserInfoViewModel.totalFollowerCountNotifier,
                                builder: (context, total, _) {
                                  return Text(
                                    "$total",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                              const Text(
                                "Followers",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Following
                        Expanded(
                          child: Column(
                            children: [
                              /// Total following count
                              ValueListenableBuilder<int>(
                                valueListenable: _myUserInfoViewModel.totalFollowingCountNotifier,
                                builder: (context, total, _) {
                                  return Text(
                                    "$total",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              /// Status message
              /// It's not visible when status message is empty
              ValueListenableBuilder<String>(
                valueListenable: _myUserInfoViewModel.statusMessageNotifier,
                builder: (context, message, _) {
                  /// Status message exists
                  if (message.isNotEmpty) {
                    return Container(
                      constraints: const BoxConstraints(
                        minHeight: 50.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          message,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }
                  /// Empty status message space
                  else {
                    return const SizedBox(height: 50);
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  // TODO : Low priority
  // TODO : Enhance loading UI
  /// Loading UI
  Widget buildLoadingStateUI() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return const Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  /// Fail UI
  Widget buildFailStateUI() {
    return Center(
      child: CustomErrorWidget(listener: () {
        fetchPostList();
      }),
    );
  }

  /// Success UI (default)
  // TODO : Low priority
  // TODO : Replace this function as a widget later
  Widget buildSuccessStateUI() {
    return ValueListenableBuilder<List<PostModel>>(
      valueListenable: _postListViewModel.currentListNotifier,
      builder: (context, list, _) {
        // TODO : Implement empty list
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: PostGridWidget(
                postModel: list[index],
                isFromMyPage: true,
                onTap: () {
                  /// Move to the selected item's index in the FeedScreen
                  context.pushNamed(
                      FeedScreenFromGrid.routeName,
                      queryParameters: {
                        "selectedIndex": "$index",
                        "title": "${list[index].getUserName}'s feed",
                      }
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      fetchPostList();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    _postListViewModel.refresh();
    // FIXME : ErrorNumber 01
    // FIXME : This initializing from setLimit() not actually working with getPostList(), and I don't know why yet
    // _postListViewModel.setLimit(value: 15);
    await _myUserInfoViewModel.getMyUserInfo();
  }

  // TODO : Must test image picker features on actual iOS device later (I don't have Apple developer account yet)
  /// Show image source selection dialog between camera/gallery
  void showSelectionGalleryCameraDialog() {
    showTwoButtonDialog(
      context: context,
      title: updateThumbnail,
      content: selectPictureSource,
      firstButtonText: gallery,

      /// Pick an image from gallery
      firstButtonListener: () async {
        var image = await pickImagesFromGallery();

        if (image != null) {
          _updateUserThumbnailViewModel.setImage(image: image);
          final state = await _updateUserThumbnailViewModel.updateThumbnail();
          _thumbnailUpdated(state: state);
        }
      },

      /// Pick images from camera
      secondButtonText: camera,
      secondButtonListener: () async {
        var image = await pickImageFromCamera();
        if (image != null) {
          _updateUserThumbnailViewModel.setImage(image: image);
          final state = await _updateUserThumbnailViewModel.updateThumbnail();
          _thumbnailUpdated(state: state);
        }
      },
    );
  }

  // TODO : Refactor this feature as a module
  /// Pick a single image from the camera.
  Future<XFile?> pickImageFromCamera() async {
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: maxImageLength,
      maxWidth: maxImageLength,
    );

    /// It prints image file's information
    if (kDebugMode && image != null) {
      await printImageInfo(fileName: image.name, file: File(image.path));
    }

    return image;
  }

  // TODO : Refactor this feature as a module
  /// Pick multiple images from the gallery.
  Future<XFile?> pickImagesFromGallery() async {
    final XFile? image = await imagePicker.pickImage(
      maxHeight: maxImageLength,
      maxWidth: maxImageLength,
      source: ImageSource.gallery,
    );

    /// It prints image file's information
    if (kDebugMode && image != null) {
      await printImageInfo(fileName: image.name, file: File(image.path));
    }

    return image;
  }

  /// Reload updated user thumbnail
  void _thumbnailUpdated({required SingleStringState.SingleStringState state}) {
    /// Success
    if (state is SingleStringState.Success) {
      _myUserInfoViewModel.updateMyUserInfoWithNewThumbnail(newThumbnail: state.getValue);
      if (context.mounted) showSnackBar(context: context, text: thumbnailUpdated);
    }
    /// Fail
    else if (state is SingleStringState.Fail) {
      if (context.mounted) showSnackBar(context: context, text: wentSomethingWrong);
    }
  }

  /// Reload updated user status message
  void _statusMessageUpdated({required CommonState.CommonState state, required String newStatusMessage}) {
    if (state is CommonState.Success) {
      _myUserInfoViewModel.setStatusMessage(statusMessage: newStatusMessage);
      if (context.mounted) {
        showSnackBar(context: context, text: statusMessageUpdated);
        Navigator.of(context).pop();
      }
    }
    /// Failed to update
    else if (state is CommonState.Fail) {
      if (context.mounted) showSnackBar(context: context, text: wentSomethingWrong);
    }
  }

  Widget popUpMenuWidget() {
    return PopupMenuButton(
      color: Colors.white,
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.black,
      ),
      onSelected: (value) {
        // TODO : Low priority
        // TODO : Enhance keyboard UI just like CommentScreen's showModalBottomKeyboard()
        /// Update user's status message
        if (value == updateStatusMessage) {
          showTextInputDialogForUpdate(
              context: context,
              title: newMessage,
              initialMessage: _myUserInfoViewModel.statusMessage,
              firstButtonText: submit,
              firstButtonListener: (String newStatusMessage) async {
                /// Not execute API when nothing's changed
                if (newStatusMessage == _myUserInfoViewModel.statusMessage) {
                  if (context.mounted) showSnackBar(context: context, text: nothingChanged);
                }
                /// Execute API
                else {
                  final state = await _updateUserStatusMessageViewModel.updateStatusMessage(newStatusMessage: newStatusMessage);
                  _statusMessageUpdated(state: state, newStatusMessage: newStatusMessage);
                }
              },
              secondButtonText: cancel,
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: updateStatusMessage,
          child: Text(updateStatusMessage),
        ),
      ],
    );
  }
}
