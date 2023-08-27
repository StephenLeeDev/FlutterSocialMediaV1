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
      /// Username
      _setMyUsername(myUsername: state.getMyUserInfo.getUserName);
      /// Thumbnail
      _setThumbnail(thumbnail: state.getMyUserInfo.getUserThumbnail);
      /// Email
      _setMyEmail(myEmail: state.getMyUserInfo.getEmail);
      /// Status message
      setStatusMessage(statusMessage: state.getMyUserInfo.getStatusMessage);
      /// Total post count
      _setTotalPostCount(totalPostCount: state.getMyUserInfo.getTotalPostCount);
      /// The number of user's followers
      _setTotalFollowerCount(totalFollowerCount: state.getMyUserInfo.getFollowers);
      /// The number of user's followings
      _setTotalFollowingCount(totalFollowingCount: state.getMyUserInfo.getFollowings);
    }
  }

  /// Fetch my user information
  Future<void> getMyUserInfo() async {
    _setMyUserInfoState(state: Loading());

    final state = await _getMyUserInfoUseCase.execute();
    _setMyUserInfoState(state: state);
  }

  /// Username
  final ValueNotifier<String> _myUsername = ValueNotifier<String>("");
  ValueNotifier<String> get myUsernameNotifier => _myUsername;
  String get myUsername => _myUsername.value;

  _setMyUsername({required String myUsername}) {
    _myUsername.value = myUsername;
  }

  /// Thumbnail
  final ValueNotifier<String> _thumbnail = ValueNotifier<String>("");
  ValueNotifier<String> get thumbnailNotifier => _thumbnail;
  String get thumbnail => _thumbnail.value;

  _setThumbnail({required String thumbnail}) {
    _thumbnail.value = thumbnail;
  }

  /// Email
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

  /// The number of user's total posts
  final ValueNotifier<int> _totalPostCount = ValueNotifier<int>(0);
  ValueNotifier<int> get totalPostCountNotifier => _totalPostCount;
  int get totalPostCount => totalPostCountNotifier.value;

  _setTotalPostCount({required int totalPostCount}) {
    _totalPostCount.value = totalPostCount;
  }

  /// The number of user's followers
  final ValueNotifier<int> _totalFollowerCount = ValueNotifier<int>(0);
  ValueNotifier<int> get totalFollowerCountNotifier => _totalFollowerCount;
  int get totalFollowerCount => totalFollowerCountNotifier.value;

  _setTotalFollowerCount({required int totalFollowerCount}) {
    _totalFollowerCount.value = totalFollowerCount;
  }

  /// The number of user's followings
  final ValueNotifier<int> _totalFollowingCount = ValueNotifier<int>(0);
  ValueNotifier<int> get totalFollowingCountNotifier => _totalFollowingCount;
  int get totalFollowingCount => totalFollowingCountNotifier.value;

  _setTotalFollowingCount({required int totalFollowingCount}) {
    _totalFollowingCount.value = totalFollowingCount;
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