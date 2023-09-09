import 'package:flutter/foundation.dart';

import '../../../../data/model/common/single_integer_state.dart';
import '../../../../domain/usecase/follow/start_follow_usecase.dart';
import '../../../../domain/usecase/follow/unfollow_usecase.dart';

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
  final ValueNotifier<SingleIntegerState> _followingState = ValueNotifier<SingleIntegerState>(Ready());
  ValueNotifier<SingleIntegerState> get followingStateNotifier => _followingState;
  SingleIntegerState get followingState => followingStateNotifier.value;

  _setFollowingState({required SingleIntegerState state}) {
    _followingState.value = state;
  }

  /// Execute the start following the user API
  Future<SingleIntegerState> startFollowTheUser({required String userEmail}) async {
    _setFollowingState(state: Loading());

    final state = await _startFollowUseCase.execute(userEmail: userEmail);
    _setFollowingState(state: state);
    return state;
  }

  /// It represents unfollowing state
  final ValueNotifier<SingleIntegerState> _unfollowingState = ValueNotifier<SingleIntegerState>(Ready());
  ValueNotifier<SingleIntegerState> get unfollowingStateNotifier => _unfollowingState;
  SingleIntegerState get unfollowingState => unfollowingStateNotifier.value;

  _setUnfollowingState({required SingleIntegerState state}) {
    _unfollowingState.value = state;
  }

  /// Execute the unfollowing the user API
  Future<SingleIntegerState> unfollowTheUser({required String userEmail}) async {
    _setUnfollowingState(state: Loading());

    final state = await _unfollowUseCase.execute(userEmail: userEmail);
    _setUnfollowingState(state: state);
    return state;
  }

}