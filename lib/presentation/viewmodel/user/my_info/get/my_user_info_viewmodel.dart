import 'package:flutter/foundation.dart';

import '../../../../../data/model/user/my_user_info.dart';
import '../../../../../data/model/user/my_user_info_state.dart';
import '../../../../../domain/usecase/user/get_my_user_info_usecase.dart';

class MyUserInfoViewModel {
  final GetMyUserInfoUseCase _getMyUserInfoUseCase;

  MyUserInfoViewModel({
    required GetMyUserInfoUseCase getMyUserInfoUseCase,
  }) : _getMyUserInfoUseCase = getMyUserInfoUseCase;

  final ValueNotifier<MyUserInfoState> _myUserInfoState = ValueNotifier<MyUserInfoState>(Ready());
  ValueNotifier<MyUserInfoState> get myUserInfoStateNotifier => _myUserInfoState;
  MyUserInfoState get myUserInfoState => myUserInfoStateNotifier.value;

  _setMyUserInfoState({required MyUserInfoState state}) {
    _myUserInfoState.value = state;
    if (state is Success) {
      _setMyEmail(myEmail: state.getMyUserInfo.getEmail);
      setStatusMessage(statusMessage: state.getMyUserInfo.getStatusMessage);
    }
  }

  Future<void> getMyUserInfo() async {
    _setMyUserInfoState(state: Loading());

    final state = await _getMyUserInfoUseCase.execute();
    _setMyUserInfoState(state: state);
  }

  String _myEmail = "";
  String get myEmail => _myEmail;

  _setMyEmail({required String myEmail}) {
    _myEmail = myEmail;
  }

  /// Update thumbnail
  updateMyUserInfoWithNewThumbnail({required String newThumbnail}) async {
    if (myUserInfoState is Success) {
      MyUserInfo myUserInfo = (myUserInfoStateNotifier.value as Success).getMyUserInfo.copyWith();
      myUserInfo.thumbnail = newThumbnail;

      _setMyUserInfoState(state: Success(myUserInfo));
    }
  }

  /// Total posts count
  final ValueNotifier<int> _totalPostCount = ValueNotifier<int>(0);
  ValueNotifier<int> get totalPostCountNotifier => _totalPostCount;
  int get totalPostCount => totalPostCountNotifier.value;

  setTotalPostCount({required int totalPostCount}) {
    _totalPostCount.value = totalPostCount;
  }

  /// Status message
  final ValueNotifier<String> _statusMessage = ValueNotifier<String>("");
  ValueNotifier<String> get statusMessageNotifier => _statusMessage;
  String get statusMessage => _statusMessage.value;

  setStatusMessage({required String statusMessage}) {
    _statusMessage.value = statusMessage;
  }

  /// Update status message
  updateMyUserInfoWithNewStatusMessage({required String newStatusMessage}) async {
    if (myUserInfoState is Success) {
      MyUserInfo myUserInfo = (myUserInfoStateNotifier.value as Success).getMyUserInfo.copyWith();
      myUserInfo.statusMessage = newStatusMessage;

      _setMyUserInfoState(state: Success(myUserInfo));
    }
  }

}