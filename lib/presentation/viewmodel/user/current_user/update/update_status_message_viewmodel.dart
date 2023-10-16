import 'package:flutter/foundation.dart';

import '../../../../../data/model/common/common_state.dart';
import '../../../../../domain/usecase/user/current_user/update_user_status_message_usecase.dart';

class UpdateUserStatusMessageViewModel {
  final UpdateUserStatusMessageUseCase _updateStatusMessageUseCase;

  UpdateUserStatusMessageViewModel({
    required UpdateUserStatusMessageUseCase updateStatusMessageUseCase,
  }) : _updateStatusMessageUseCase = updateStatusMessageUseCase;

  /// It represents state
  final ValueNotifier<CommonState> _updateStatusMessageState = ValueNotifier<CommonState>(Ready());
  ValueNotifier<CommonState> get updateStatusMessageStateNotifier => _updateStatusMessageState;
  CommonState get updateStatusMessageState => updateStatusMessageStateNotifier.value;

  setUpdateStatusMessageState(CommonState state) {
    _updateStatusMessageState.value = state;
    checkIsValid();
  }

  /// Original status message
  String _originalStatusMessage = "";
  String get originalStatusMessage => _originalStatusMessage;

  setOriginalStatusMessage(String originalStatusMessage) {
    _originalStatusMessage = originalStatusMessage;
    checkIsValid();
  }

  /// New status message
  String _newStatusMessage = "";
  String get newStatusMessage => _newStatusMessage;

  setNewStatusMessage(String newStatusMessage) {
    _newStatusMessage = newStatusMessage;
    checkIsValid();
  }

  checkIsValid() {
    final valid = newStatusMessage.isNotEmpty && originalStatusMessage != newStatusMessage && updateStatusMessageState is! Loading;
    setIsValid(valid);
  }

  /// It represents whether can be updated
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isValidNotifier => _isValid;
  bool get isValid => _isValid.value;

  setIsValid(bool value) {
    _isValid.value = value;
  }

  /// Execute API
  Future<CommonState> updateStatusMessage() async {
    setUpdateStatusMessageState(Loading());

    final state = await _updateStatusMessageUseCase.execute(newStatusMessage: newStatusMessage);
    setUpdateStatusMessageState(state);
    return state;
  }

  /// Initialize states after success/cancel task
  initUpdateStatus() {
    setUpdateStatusMessageState(Ready());
    setNewStatusMessage("");
  }

}