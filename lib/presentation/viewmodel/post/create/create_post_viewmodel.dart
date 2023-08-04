import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/model/post/create/create_post_model.dart';
import '../../../../data/model/post/item/post_item_state.dart';
import '../../../../domain/usecase/post/create/create_post_usecase.dart';
import '../../../util/converter/file_converter_util.dart';

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

  /// Image list
  final ValueNotifier<List<XFile>> _imageList = ValueNotifier<List<XFile>>(List.empty());
  ValueNotifier<List<XFile>> get imageListNotifier => _imageList;
  List<XFile> get imageList => _imageList.value;

  _setImageList({required List<XFile> list}) {
    _imageList.value = list;
    _checkIsValid();
  }

  /// Add additional images to the _imageList
  addAdditionalImagesToList({required List<XFile> list}) {
    List<XFile> copyList = List.from(imageList);
    copyList.addAll(list);
    _setImageList(list: copyList);
  }

  /// remove the certain image from the _imageList by index
  removeImageFromListByIndex({required int index}) {
    List<XFile> copyList = List.from(imageList);
    copyList.removeAt(index);
    _setImageList(list: copyList);
  }

  /// Description
  final ValueNotifier<String> _description = ValueNotifier<String>("");
  ValueNotifier<String> get descriptionNotifier => _description;
  String get description => _description.value;

  setDescription({required String value}) {
    _description.value = value;
    _checkIsValid();
  }

  /// It represents whether a post can be created
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isValidNotifier => _isValid;
  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  _checkIsValid() {
    final valid = description.isNotEmpty && createPostState is! Loading;
    _setIsValid(value: valid);
  }

  /// Execute create a post API
  Future<PostItemState> createPost() async {
    setPostItemState(createPostState: Loading());
    final CreatePostModel createPostModel = CreatePostModel(
      description: description,
      images: await convertXFilesToMultipart(files: imageList),
    );

    final state = await _createPostUseCase.execute(createPostModel: createPostModel);
    setPostItemState(createPostState: state);
    return state;
  }

}