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

  _setUpdateStatusMessageState({required CommonState state}) {
    _updateStatusMessageState.value = state;
  }

  /// New status message
  final ValueNotifier<String> _newStatusMessage = ValueNotifier<String>("");
  ValueNotifier<String> get newStatusMessageNotifier => _newStatusMessage;
  String get newStatusMessage => _newStatusMessage.value;

  setNewStatusMessage({required String newStatusMessage}) {
    _newStatusMessage.value = newStatusMessage;
  }

  /// Execute API
  Future<CommonState> updateStatusMessage({required String newStatusMessage}) async {
    _setUpdateStatusMessageState(state: Loading());

    final state = await _updateStatusMessageUseCase.execute(newStatusMessage: newStatusMessage);
    _setUpdateStatusMessageState(state: state);
    return state;
  }

}