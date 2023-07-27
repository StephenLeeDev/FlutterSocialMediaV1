import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../data/model/post/create/create_post_model.dart';
import '../../../../data/model/post/item/post_item_state.dart';
import '../../../../domain/usecase/post/create/create_post_usecase.dart';

/// This ViewModel is responsible for handling the creation of new post
class CreatePostViewModel {
  final CreatePostUseCase _createPostUseCase;

  CreatePostViewModel({
    required CreatePostUseCase createPostUseCase,
  }) : _createPostUseCase = createPostUseCase;

  /// It represents state
  final ValueNotifier<PostItemState> _createPostState = ValueNotifier<PostItemState>(Ready());
  ValueNotifier<PostItemState> get createPostStateNotifier => _createPostState;
  PostItemState get createPostState => _createPostState.value;

  setPostItemState({required PostItemState createPostState}) {
    _createPostState.value = createPostState;
  }

  /// Images
  final ValueNotifier<List<MultipartFile>> _imageList = ValueNotifier<List<MultipartFile>>(List.empty());
  ValueNotifier<List<MultipartFile>> get imageListNotifier => _imageList;
  List<MultipartFile> get imageList => _imageList.value;

  setImageList({required List<MultipartFile> list}) {
    _imageList.value = list;
    checkIsValid();
  }

  /// Description
  final ValueNotifier<String> _description = ValueNotifier<String>("");
  ValueNotifier<String> get descriptionNotifier => _description;
  String get description => _description.value;

  setDescription({required String value}) {
    _description.value = value;
    checkIsValid();
  }

  /// It represents whether a post can be created
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isValidNotifier => _isValid;
  bool get isValid => _isValid.value;

  setIsValid({required bool value}) {
    _isValid.value = value;
  }

  checkIsValid() {
    final valid = description.isNotEmpty && createPostState is! Loading;
    setIsValid(value: valid);
  }

  /// Execute create a post API
  Future<PostItemState> createPost() async {
    setPostItemState(createPostState: Loading());
    final CreatePostModel createPostModel = CreatePostModel(
      description: description,
      images: imageList,
    );

    final state = await _createPostUseCase.execute(createPostModel: createPostModel);
    setPostItemState(createPostState: state);
    return state;
  }

}