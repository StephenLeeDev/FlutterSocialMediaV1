import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../data/model/common/single_string_state.dart';
import '../../../../../domain/usecase/user/current_user/update_user_thumbnail_usecase.dart';
import '../../../../util/converter/file_converter_util.dart';

class UpdateUserThumbnailViewModel {
  final UpdateUserThumbnailUseCase _updateThumbnailUseCase;

  UpdateUserThumbnailViewModel({
    required UpdateUserThumbnailUseCase updateThumbnailUseCase,
  }) : _updateThumbnailUseCase = updateThumbnailUseCase;

  /// It represents state
  final ValueNotifier<SingleStringState> _updateThumbnailState = ValueNotifier<SingleStringState>(Ready());
  ValueNotifier<SingleStringState> get updateThumbnailStateNotifier => _updateThumbnailState;
  SingleStringState get updateThumbnailState => updateThumbnailStateNotifier.value;

  _setUpdateThumbnailState({required SingleStringState state}) {
    _updateThumbnailState.value = state;
  }

  /// Image
  final ValueNotifier<XFile> _image = ValueNotifier<XFile>(XFile(''));
  ValueNotifier<XFile> get imageNotifier => _image;
  XFile get image => _image.value;

  setImage({required XFile image}) {
    _image.value = image;
  }

  /// Execute API
  Future<SingleStringState> updateThumbnail() async {
    _setUpdateThumbnailState(state: Loading());

    final state = await _updateThumbnailUseCase.execute(newThumbnail: await convertXFileToMultipart(file: image));
    _setUpdateThumbnailState(state: state);
    return state;
  }

}