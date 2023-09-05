import 'package:flutter/foundation.dart';

import '../../../data/model/common/common_state.dart';
import '../../../domain/usecase/follow/start_follow_usecase.dart';
import '../../../domain/usecase/follow/unfollow_usecase.dart';

/// Follow/Unfollow ViewModel
/// It handling start follow feature with calling the follow API[StartFollowUseCase]
/// It handling unfollow feature with calling the unfollow API[UnfollowUseCase]

// REVIEW : Actually, I tried to implement these features into two different ViewModels
// REVIEW : But I thought they are almost the same features, and they are always used together
// REVIEW : So I just implemented these features as one ViewModel
// REVIEW : In my opinion, it's close to the best practice
// REVIEW : But if the [FollowViewModel] becomes more complicated later, then I might have to separate them
class FollowViewModel {
  final StartFollowUseCase _startFollowUseCase;
  final UnfollowUseCase _unfollowUseCase;

  FollowViewModel({
    required StartFollowUseCase startFollowUseCase,
    required UnfollowUseCase unfollowUseCase,
  }) : _startFollowUseCase = startFollowUseCase,
    _unfollowUseCase = unfollowUseCase;

  /// It represents following state
  final ValueNotifier<CommonState> _followingState = ValueNotifier<CommonState>(Ready());
  ValueNotifier<CommonState> get followingStateNotifier => _followingState;
  CommonState get followingState => followingStateNotifier.value;

  _setFollowingState({required CommonState state}) {
    _followingState.value = state;
  }

  /// Execute the start following the user API
  Future<CommonState> startFollowTheUser({required String userEmail}) async {
    _setFollowingState(state: Loading());

    final state = await _startFollowUseCase.execute(userEmail: userEmail);
    _setFollowingState(state: state);
    return state;
  }

  /// It represents unfollowing state
  final ValueNotifier<CommonState> _unfollowingState = ValueNotifier<CommonState>(Ready());
  ValueNotifier<CommonState> get unfollowingStateNotifier => _unfollowingState;
  CommonState get unfollowingState => unfollowingStateNotifier.value;

  _setUnfollowingState({required CommonState state}) {
    _unfollowingState.value = state;
  }

  /// Execute the unfollowing the user API
  Future<CommonState> unfollowTheUser({required String userEmail}) async {
    _setUnfollowingState(state: Loading());

    final state = await _unfollowUseCase.execute(userEmail: userEmail);
    _setUnfollowingState(state: state);
    return state;
  }

}