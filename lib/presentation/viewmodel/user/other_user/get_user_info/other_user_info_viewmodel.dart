import 'package:flutter/foundation.dart';

import '../../../../../data/model/user/detail_user_info_state.dart';
import '../../../../../domain/usecase/user/other_user/get_user_info_by_email_usecase.dart';

// TODO : Low priority
// TODO : Might integrate with CurrentUserPostGridListViewModel later
// TODO : CurrentUserInfoViewModel and CurrentUserPostGridListViewModel have similar features,
// TODO : but I didn't consider their structure at the beginning

// TODO : Of course, it's not necessary because they are similar but also have different features and states
// TODO : Maybe, it's already the best practice that separate them like this
class OtherUserInfoViewModel {
  final GetUserInfoByEmailUseCase _getUserInfoByEmailUseCase;

  OtherUserInfoViewModel({
    required GetUserInfoByEmailUseCase getUserInfoByEmailUseCase,
  }) : _getUserInfoByEmailUseCase = getUserInfoByEmailUseCase;

  final ValueNotifier<DetailUserInfoState> _userInfoState = ValueNotifier<DetailUserInfoState>(Ready());
  ValueNotifier<DetailUserInfoState> get userInfoStateNotifier => _userInfoState;
  DetailUserInfoState get userInfoState => userInfoStateNotifier.value;

  _setUserInfoState({required DetailUserInfoState state}) {
    _userInfoState.value = state;
    if (state is Success) {
      /// Username
      _setUsername(username: state.getUserInfo.getUserName);
      /// Thumbnail
      _setThumbnail(thumbnail: state.getUserInfo.getThumbnail);
      /// Email
      _setEmail(mail: state.getUserInfo.getEmail);
      /// Status message
      setStatusMessage(statusMessage: state.getUserInfo.getStatusMessage);
      /// Total post count
      _setTotalPostCount(totalPostCount: state.getUserInfo.getTotalPostCount);
      /// The number of user's followers
      _setTotalFollowerCount(totalFollowerCount: state.getUserInfo.getFollowerCount);
      /// The number of user's followings
      _setTotalFollowingCount(totalFollowingCount: state.getUserInfo.getFollowingCount);
    }
  }

  /// Fetch user information
  Future<void> getUserInfoByEmail({required String userEmail}) async {
    _setUserInfoState(state: Loading());

    final state = await _getUserInfoByEmailUseCase.execute(userEmail: userEmail);
    _setUserInfoState(state: state);
  }

  /// Username
  final ValueNotifier<String> _username = ValueNotifier<String>("");
  ValueNotifier<String> get usernameNotifier => _username;
  String get username => _username.value;

  _setUsername({required String username}) {
    _username.value = username;
  }

  /// Thumbnail
  final ValueNotifier<String> _thumbnail = ValueNotifier<String>("");
  ValueNotifier<String> get thumbnailNotifier => _thumbnail;
  String get thumbnail => _thumbnail.value;

  _setThumbnail({required String thumbnail}) {
    _thumbnail.value = thumbnail;
  }

  /// Email
  String _email = "";
  String get mail => _email;

  _setEmail({required String mail}) {
    _email = mail;
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

  /// The user's status message
  final ValueNotifier<String> _statusMessage = ValueNotifier<String>("");
  ValueNotifier<String> get statusMessageNotifier => _statusMessage;
  String get statusMessage => _statusMessage.value;

  setStatusMessage({required String statusMessage}) {
    _statusMessage.value = statusMessage;
  }

  /// It represents current user is following the user, or not
  final ValueNotifier<bool> _isFollowing = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isFollowingNotifier => _isFollowing;
  bool get isFollowing => _isFollowing.value;

  setIsFollowing({required bool isFollowing}) {
    _isFollowing.value = isFollowing;
  }

}