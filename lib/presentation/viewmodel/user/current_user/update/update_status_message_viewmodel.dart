import 'package:flutter/foundation.dart';

import '../../../../../data/model/common/common_state.dart';
import '../../../../../domain/usecase/user/current_user/update_user_status_message_usecase.dart';

class UpdateUserStatusMessageViewModel {
  final UpdateUserStatusMessageUseCase _updateUserStatusMessageUseCase;

  UpdateUserStatusMessageViewModel({
    required UpdateUserStatusMessageUseCase updateUserStatusMessageUseCase,
  }) : _updateUserStatusMessageUseCase = updateUserStatusMessageUseCase;

  /// It represents state
  final ValueNotifier<CommonState> _updateStatusMessageState = ValueNotifier<CommonState>(Ready());
  ValueNotifier<CommonState> get updateStatusMessageStateNotifier => _updateStatusMessageState;
  CommonState get updateStatusMessageState => updateStatusMessageStateNotifier.value;

  setUpdateStatusMessageState(CommonState state) {
    _updateStatusMessageState.value = state;
    checkIsValid();
  }

  /// Previous status message
  String _previousStatusMessage = "";
  String get previousStatusMessage => _previousStatusMessage;

  setPreviousStatusMessage(String previousStatusMessage) {
    _previousStatusMessage = previousStatusMessage;
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
    final valid = newStatusMessage.isNotEmpty && previousStatusMessage != newStatusMessage && updateStatusMessageState is! Loading;
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

    final state = await _updateUserStatusMessageUseCase.execute(newStatusMessage: newStatusMessage);
    setUpdateStatusMessageState(state);
    return state;
  }

  /// Initialize states after success task
  initUpdateStatus() {
    setUpdateStatusMessageState(Ready());
    setPreviousStatusMessage("");
    setNewStatusMessage("");
  }

}